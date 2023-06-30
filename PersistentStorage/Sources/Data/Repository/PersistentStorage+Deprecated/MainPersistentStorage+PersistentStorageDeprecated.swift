import Combine
import Foundation

// MARK: - Deprecated methods
extension MainPersistentStorage: PersistentStorageDeprecated {
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
    @available(*, deprecated, message: "This will be removed in 3.0.0. This method was renamed.", renamed: "read")
    public func readWithPublisher<T>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError> {
        read(
            valueType: valueType,
            valueKey: valueKey,
            userDefaults: type
        )
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
    @available(*, deprecated, message: "This will be removed in 3.0.0. This method was renamed.", renamed: "read")
    public func readWithPublisher<T: Codable>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError> {
        read(
            valueType: valueType,
            valueKey: valueKey,
            userDefaults: type
        )
    }
}
