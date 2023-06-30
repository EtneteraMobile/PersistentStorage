import Combine
import Foundation

public class MainPersistentStorage: PersistentStorage {
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
    @discardableResult
    public func store<T>(
        _ value: T?,
        for key: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<Void, PersistentStorageError> {
        userDefaults(for: type)
            .map { [weak self] userDefaults in
                if let persistedValue = userDefaults.value(forKey: key) as? T {
                    self?.log(
                        message: "ℹ️ Rewritten original value {\(persistedValue)} for key {\(key)} in userDefaults {\(type)} while persisting",
                        for: .debug
                    )
                }
                self?.log(
                    message: "✅ Successfully persisted value {\(String(describing: value))} for key {\(key)} in userDefaults {\(type)}",
                    for: .debug
                )

                userDefaults.set(
                    value,
                    forKey: key
                )
                // This operation is always successful
                return ()
            }
            .eraseToAnyPublisher()
    }

    /// Method for removing a value with assigned key from the user defaults storage.
    ///
    /// - Parameters:
    ///     - key: Key that will be assigned to value
    @discardableResult
    public func remove(
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<Void, PersistentStorageError> {
        userDefaults(for: type)
            .map { [weak self] userDefaults in
                userDefaults.removeObject(forKey: valueKey)
                self?.log(
                    message: "✅ Successfully removed value with key {\(valueKey)} in userDefaults {\(type)}",
                    for: .debug
                )
                // This operation is always successful
                return ()
            }
            .eraseToAnyPublisher()
    }
    /// Method for reading a value with given key and type. Result is returned as a publisher.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    public func read<T>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError> {
        userDefaults(for: type)
            .flatMap { [weak self] userDefaults -> AnyPublisher<T, PersistentStorageError> in
                guard let persistedValue = userDefaults.value(forKey: valueKey) as? T else {
                    if userDefaults.value(forKey: valueKey) != nil {
                        self?.log(
                            message: "❌ Value with given key exists in userDefaults {\(type)}, but method is unable to parse the value with given type.",
                            for: .failure
                        )
                        return Fail(error: PersistentStorageError.noValueFoundWithGivenType).eraseToAnyPublisher()
                    } else {
                        self?.log(
                            message: "ℹ️ Value with given key does not exist in userDefaults {\(type)}, returning `noValueFound` failure.",
                            for: .failure
                        )
                        return Fail(error: PersistentStorageError.noValueFound).eraseToAnyPublisher()
                    }
                }
                self?.log(
                    // swiftlint:disable:next line_length
                    message: "✅ Successfully returned persisted value in userDefaults {\(type)} with key {\(valueKey)} and associated value {\(persistedValue)}",
                    for: .debug
                )
                return Just(persistedValue)
                    .setFailureType(to: PersistentStorageError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// Method for observing a value with given user defaults `KeyPath`.
    ///
    /// - Possible failures:
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - keyPath: Specified key represented by user defaults `KeyPath` value.
    public func observe<T>(
        keyPath: KeyPath<UserDefaults, T?>,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError> {
        userDefaults(for: type)
            .flatMap { userDefaults in
                userDefaults
                    .publisher(for: keyPath)
                    .handleEvents(
                        receiveOutput: { [weak self] value in
                            self?.log(
                                message: "✅ Observing value {\(String(describing: value))} in userDefaults {\(type)}",
                                for: .debug
                            )
                        }
                    )
                    .flatMap { observedValue -> AnyPublisher<T, PersistentStorageError> in
                        guard let observedValue else {
                            return Fail(error: .noValueFound).eraseToAnyPublisher()
                        }
                        return Just(observedValue)
                            .setFailureType(to: PersistentStorageError.self)
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Internal methods

    func userDefaults(for type: UserDefaultsType) -> AnyPublisher<UserDefaults, PersistentStorageError> {
        guard let userDefaults = UserDefaults(type: type) else {
            return Fail(error: PersistentStorageError.cannotCreateUserDefaults).eraseToAnyPublisher()
        }

        return Just(userDefaults)
            .setFailureType(to: PersistentStorageError.self)
            .eraseToAnyPublisher()
    }

    /// TODO
    func log(
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