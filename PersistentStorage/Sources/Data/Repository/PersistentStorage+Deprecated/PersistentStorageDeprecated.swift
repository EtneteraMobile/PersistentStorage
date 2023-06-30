import Combine
import Foundation

public extension PersistentStorageDeprecated {
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
    @available(*, deprecated, message: "This will be removed in 3.0.0. This method was renamed.", renamed: "read")
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

    /// Method for reading a codable value with given key and type. Result is returned as a publisher.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    ///     - userDefaults: .standard
    @available(*, deprecated, message: "This will be removed in 3.0.0. This method was renamed.", renamed: "read")
    func readWithPublisher<T: Codable>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T, PersistentStorageError> {
        readWithPublisher(
            valueType: valueType,
            valueKey: valueKey,
            userDefaults: .standard
        )
    }
}

public protocol PersistentStorageDeprecated {
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
    func readWithPublisher<T>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError>

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
    func readWithPublisher<T: Codable>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError>
}
