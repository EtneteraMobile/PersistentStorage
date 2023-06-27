import Foundation
import Combine

/// The `PersistentStorage` class wraps apple native `UserDefaults` class and  provides a custom
/// programmatic interface for complex accessing user defaults database.
public final class PersistentStorage {

    private let userDefaults = UserDefaults.standard
    private let logConfiguration: LogConfiguration

    /// Initialization of `PersistentStorage`
    /// - Parameters:
    ///   - logConfiguration:
    ///         `logSetup`: Defines range of debug loggs
    ///         `logger`: Provide custom log handler. As default log handling is used `Swift.print`
    public init(logConfiguration: LogConfiguration) {
        self.logConfiguration = logConfiguration
    }

    /// Method for storing a value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    @discardableResult public func store<T>(
        _ value: T?,
        for key: String
    ) -> AnyPublisher<Bool, Never> {
        if let persistedValue = userDefaults.value(forKey: key) as? T {
            log(
                message: "ℹ️ Rewritten original value {\(persistedValue)} for key {\(key)} while persisting",
                for: .debug
            )
        }
        log(
            message: "✅ Successfully persisted value {\(String(describing: value))} for key {\(key)}",
            for: .debug
        )

        userDefaults.set(
            value,
            forKey: key
        )
        // This operation is always successful
        return Just(true).eraseToAnyPublisher()
    }

    /// TODO
    @discardableResult
    public func remove(
        valueKey: String
    ) -> AnyPublisher<Bool, Never> {
        userDefaults.set(
            nil,
            forKey: valueKey
        )
        log(
            message: "✅ Successfully removed value with key {\(valueKey)}",
            for: .debug
        )
        // This operation is always successful
        return Just(true).eraseToAnyPublisher()
    }

    /// TODO
    public func read<T>(
        valueType: T.Type,
        valueKey: String
    ) throws -> T? {
        try getPersistedValue(
            valueType: valueType,
            valueKey: valueKey
        )
    }

    /// TODO
    public func readWithPublisher<T>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T?, PersistentStorageError> {
        do {
            let persistedValue = try getPersistedValue(
                valueType: valueType,
                valueKey: valueKey
            )
            return Just(
                persistedValue
            )
            .setFailureType(to: PersistentStorageError.self)
            .eraseToAnyPublisher()
        } catch {
            guard let error = error as? PersistentStorageError else {
                return Fail(
                    error: PersistentStorageError.undefined
                ).eraseToAnyPublisher()
            }
            return Fail(
                error: error
            ).eraseToAnyPublisher()
        }
    }

    /// TODO
    public func observe<T>(
        keyPath: KeyPath<UserDefaults, T?>
    ) -> AnyPublisher<T?, Never> {
        userDefaults.publisher(
            for: keyPath
        )
        .handleEvents(
            receiveOutput: { [weak self] value in
                self?.log(
                    message: "✅ Observing value {\(String(describing: value))}.",
                    for: .debug
                )
            }
        )
        .eraseToAnyPublisher()
    }

    /// TODO
    private func getPersistedValue<T>(
        valueType: T.Type,
        valueKey: String
    ) throws -> T? {
        guard let persistedValue = userDefaults.value(forKey: valueKey) as? T else {
            if userDefaults.value(forKey: valueKey) != nil {
                log(
                    message: "❌ Value with given key exists, but method is unable to parse the value with given type.",
                    for: .failure
                )
                throw PersistentStorageError.noValueFoundWithGivenType
            } else {
                log(
                    message: "ℹ️ Value with given key does not exist, returning nil.",
                    for: .failure
                )
                return nil
            }
        }
        log(
            // swiftlint:disable:next line_length
            message: "✅ Successfully returned persisted value with key {\(valueKey)} and associated value {\(persistedValue)}",
            for: .debug
        )
        return persistedValue
    }

    /// TODO
    private func log(
        message: String,
        for logLevel: LogLevel
    ) {
        guard logConfiguration.logSetup != .none else {
            return
        }

        let isDebugMode: Bool = logConfiguration.logSetup == .debug
        && logConfiguration.logSetup != .onlyFailures
        && (
            logLevel == .debug
            || logLevel == .failure
        )

        let isOnlyFailureMode: Bool = logConfiguration.logSetup == .onlyFailures
        && logLevel == .failure

        guard isDebugMode || isOnlyFailureMode else {
            return
        }
        logConfiguration.logger(message)
    }
}
