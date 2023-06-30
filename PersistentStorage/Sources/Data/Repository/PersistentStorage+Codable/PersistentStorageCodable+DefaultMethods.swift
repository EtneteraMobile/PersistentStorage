import Combine
import Foundation

public extension PersistentStorageCodable {
    /// Method for storing a codable value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    ///     - userDefaults: .standard
    @discardableResult
    func storeCodable<T: Codable>(
        _ value: T?,
        for key: String
    ) -> AnyPublisher<Void, PersistentStorageError> {
        storeCodable(
            value,
            for: key,
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
    func readCodable<T: Codable>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T, PersistentStorageError> {
        readCodable(
            valueType: valueType,
            valueKey: valueKey,
            userDefaults: .standard
        )
    }
}
