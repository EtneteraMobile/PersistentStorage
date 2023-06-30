import Combine
import Foundation

// MARK: - Deprecated methods
extension MainPersistentStorage: PersistentStorageDeprecated {
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

    @available(*, deprecated, message: "This will be removed in 3.0.0. This method was renamed.", renamed: "readCodable")
    public func readWithPublisher<T: Codable>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError> {
        readCodable(
            valueType: valueType,
            valueKey: valueKey,
            userDefaults: type
        )
    }
}
