import Combine
import Foundation

public extension PersistentStorage {
    /// Method for storing a value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    ///     - userDefaults: .standard
    @discardableResult
    func store<T>(
        _ value: T?,
        for key: String
    ) -> AnyPublisher<Void, PersistentStorageError> {
        store(
            value,
            for: key,
            userDefaults: .standard
        )
    }

    /// Method for removing a value with assigned key from the user defaults storage.
    ///
    /// - Parameters:
    ///     - key: Key that will be assigned to value
    ///     - userDefaults: .standard
    @discardableResult
    func remove(
        valueKey: String
    ) -> AnyPublisher<Void, PersistentStorageError> {
        remove(
            valueKey: valueKey,
            userDefaults: .standard
        )
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
    ///     - userDefaults: .standard
    func readWithPublisher<T>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T, PersistentStorageError> {
        readWithPublisher(
            valueType: valueType,
            valueKey: valueKey,
            userDefaults: .standard
        )
    }

    /// Method for observing a value with given user defaults `KeyPath`.
    ///
    /// - Possible failures:
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - keyPath: Specified key represented by user defaults `KeyPath` value.
    ///     - userDefaults: .standard
    func observe<T>(
        keyPath: KeyPath<UserDefaults, T?>
    ) -> AnyPublisher<T, PersistentStorageError> {
        observe(
            keyPath: keyPath,
            userDefaults: .standard
        )
    }
}
