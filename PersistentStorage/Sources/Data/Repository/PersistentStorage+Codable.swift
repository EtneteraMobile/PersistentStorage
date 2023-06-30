import Combine
import Foundation

public protocol PersistentStorageCodable {
    /// Method for storing a codable value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    @discardableResult
    func store<T: Codable>(
        _ value: T?,
        for key: String
    ) -> AnyPublisher<Void, PersistentStorageError>

    /// Method for reading a codable value with given key and type. Result is returned as a publisher.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    func readWithPublisher<T: Codable>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T, PersistentStorageError>
}

extension MainPersistentStorage: PersistentStorageCodable {
    /// Method for storing a codable value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    @discardableResult
    public func store<T: Codable>(
        _ value: T?,
        for key: String
    ) -> AnyPublisher<Void, PersistentStorageError> {
        if let persistedValue: T = userDefaults.codableValue(forKey: key) {
            log(
                message: "ℹ️ Rewritten original value {\(persistedValue)} for key {\(key)} while persisting",
                for: .debug
            )
        }
        log(
            message: "✅ Successfully persisted value {\(String(describing: value))} for key {\(key)}",
            for: .debug
        )

        userDefaults.codableSet(
            value,
            forKey: key
        )
        // This operation is always successful
        return Just(())
            .setFailureType(to: PersistentStorageError.self)
            .eraseToAnyPublisher()
    }

    /// Method for reading a codable value with given key and type. Result is returned as a publisher.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    public func readWithPublisher<T: Codable>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T, PersistentStorageError> {
        do {
            let persistedValue = try getCodablePersistedValue(
                valueType: valueType,
                valueKey: valueKey
            )

            return Just(persistedValue)
                .setFailureType(to: PersistentStorageError.self)
                .eraseToAnyPublisher()
        } catch {
            guard let error = error as? PersistentStorageError else {
                return Fail(error: PersistentStorageError.undefined)
                    .eraseToAnyPublisher()
            }

            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }

    private func getCodablePersistedValue<T: Codable>(
        valueType: T.Type,
        valueKey: String
    ) throws -> T {
        guard let persistedValue: T = userDefaults.codableValue(forKey: valueKey) else {
            if userDefaults.value(forKey: valueKey) != nil {
                log(
                    message: "❌ Value with given key exists, but method is unable to parse the value with given type.",
                    for: .failure
                )
                throw PersistentStorageError.noValueFoundWithGivenType
            } else {
                log(
                    message: "ℹ️ Value with given key does not exist, returning `noValueFound` failure.",
                    for: .failure
                )
                throw PersistentStorageError.noValueFound
            }
        }
        log(
            // swiftlint:disable:next line_length
            message: "✅ Successfully returned persisted value with key {\(valueKey)} and associated value {\(persistedValue)}",
            for: .debug
        )
        return persistedValue
    }
}
