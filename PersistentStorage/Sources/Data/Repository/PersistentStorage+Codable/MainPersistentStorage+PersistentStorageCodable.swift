import Combine
import Foundation

extension MainPersistentStorage: PersistentStorageCodable {
    @discardableResult
    public func storeCodable<T: Codable>(
        _ value: T?,
        for key: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<Void, PersistentStorageError> {
        userDefaults(for: type)
            .map { [weak self] userDefaults in
                if let persistedValue: T = userDefaults.codableValue(forKey: key) {
                    self?.log(
                        message: "ℹ️ Rewritten original codable value {\(persistedValue)} for key {\(key)} in userDefaults {\(type)} while persisting",
                        for: .debug
                    )
                }
                self?.log(
                    message: "✅ Successfully persisted codable value {\(String(describing: value))} for key {\(key)} in userDefaults {\(type)}",
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

    public func readCodable<T: Codable>(
        valueType: T.Type,
        valueKey: String,
        userDefaults type: UserDefaultsType
    ) -> AnyPublisher<T, PersistentStorageError> {
        userDefaults(for: type)
            .flatMap { [weak self] userDefaults -> AnyPublisher<T, PersistentStorageError> in
                guard let persistedValue: T = userDefaults.codableValue(forKey: valueKey) else {
                    if userDefaults.value(forKey: valueKey) != nil {
                        self?.log(
                            message: "❌ Value with given key exists in userDefaults {\(type)}, but method is unable to parse the value with given codable type.",
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
                    message: "✅ Successfully returned persisted codable value in userDefaults {\(type)} with key {\(valueKey)} and associated codable value {\(persistedValue)}",
                    for: .debug
                )
                return Just(persistedValue)
                    .setFailureType(to: PersistentStorageError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
