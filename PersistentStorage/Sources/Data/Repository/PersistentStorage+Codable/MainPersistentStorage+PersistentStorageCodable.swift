import Combine
import Foundation

extension MainPersistentStorage: PersistentStorageCodable {
    /// Method for storing a codable value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    ///     - userDefaults: Type of UserDefaults to use
    @discardableResult
    public func store<T: Codable>(
        _ value: T?,
        for key: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<Void, PersistentStorageError> {
        userDefaults(for: type)
            .map { [weak self] userDefaults in
                if let persistedValue: T = userDefaults.codableValue(forKey: key) {
                    self?.log(
                        message: "ℹ️ Rewritten original value {\(persistedValue)} for key {\(key)} while persisting",
                        for: .debug
                    )
                }
                self?.log(
                    message: "✅ Successfully persisted value {\(String(describing: value))} for key {\(key)}",
                    for: .debug
                )

                userDefaults.codableSet(
                    value,
                    forKey: key
                )
                // This operation is always successful
                return ()
            }
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
    ///     - userDefaults: Type of UserDefaults to use
    public func readWithPublisher<T: Codable>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError> {
        userDefaults(for: type)
            .flatMap { [weak self] userDefaults -> AnyPublisher<T, PersistentStorageError> in
                guard let persistedValue: T = userDefaults.codableValue(forKey: valueKey) else {
                    if userDefaults.value(forKey: valueKey) != nil {
                        self?.log(
                            message: "❌ Value with given key exists, but method is unable to parse the value with given type.",
                            for: .failure
                        )
                        return Fail(error: PersistentStorageError.noValueFoundWithGivenType).eraseToAnyPublisher()
                    } else {
                        self?.log(
                            message: "ℹ️ Value with given key does not exist, returning `noValueFound` failure.",
                            for: .failure
                        )
                        return Fail(error: PersistentStorageError.noValueFound).eraseToAnyPublisher()
                    }
                }
                self?.log(
                    // swiftlint:disable:next line_length
                    message: "✅ Successfully returned persisted value with key {\(valueKey)} and associated value {\(persistedValue)}",
                    for: .debug
                )
                return Just(persistedValue)
                    .setFailureType(to: PersistentStorageError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
