import Combine
import Foundation

extension UserDefaults {
    func codableSet<Element: Codable>(_ value: Element, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        self.setValue(data, forKey: key)
    }

    func codableValue<Element: Codable>(forKey key: String) -> Element? {
        guard let data = self.data(forKey: key) else {
            return nil
        }

        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}

public extension PersistentStorage {
    @discardableResult
    func store<T: Codable>(
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

    func readWithPublisher<T: Codable>(
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

    func getCodablePersistedValue<T: Codable>(
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
