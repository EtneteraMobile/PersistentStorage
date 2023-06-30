import Combine
import Foundation

/// The `PersistentStorage` protocol wraps Apple native `UserDefaults` class and  provides a custom
/// programmatic interface for complex accessing user defaults database.
public protocol PersistentStorage: PersistentStorageCodable, PersistentStorageDeprecated {
    /// Method for storing a value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    ///     - userDefaults: Type of UserDefaults to use
    @discardableResult
    func store<T>(
        _ value: T?,
        for key: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<Void, PersistentStorageError>

    /// Method for removing a value with assigned key from the user defaults storage.
    ///
    /// - Parameters:
    ///     - key: Key that will be assigned to value
    ///     - userDefaults: Type of UserDefaults to use
    @discardableResult
    func remove(
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<Void, PersistentStorageError>

    /// Method for reading a value with given key and type. Result is returned as a publisher.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    ///     - userDefaults: Type of UserDefaults to use
    func read<T>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError>

    /// Method for observing a value with given user defaults `KeyPath`.
    ///
    /// - Possible failures:
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - keyPath: Specified key represented by user defaults `KeyPath` value.
    ///     - userDefaults: Type of UserDefaults to use
    func observe<T>(
        keyPath: KeyPath<UserDefaults, T?>,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError>
}
