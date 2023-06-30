import Combine
import Foundation

// MARK: - Deprecated methods
extension MainPersistentStorage: PersistentStorageDeprecated {
    // MARK: - Remove in 2.0.0

    /// Method for removing a value with assigned key from the user defaults storage.
    ///
    /// - Parameters:
    ///     - key: Key that will be assigned to value
    @available(*, deprecated, message: "This will be removed in 2.0.0. Use the store method that returns AnyPublisher<Void, PersistentStorageError>")
    @discardableResult
    public func remove(
        valueKey: String
    ) -> AnyPublisher<Bool, Never> {
        userDefaults.removeObject(forKey: valueKey)
        log(
            message: "✅ Successfully removed value with key {\(valueKey)}",
            for: .debug
        )
        // This operation is always successful
        return Just(true).eraseToAnyPublisher()
    }

    /// Method for storing a value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    @available(*, deprecated, message: "This will be removed in 2.0.0. Use the store method that returns AnyPublisher<Void, PersistentStorageError>")
    @discardableResult
    public func store<T>(
        _ value: T?,
        for key: String
    ) -> AnyPublisher<Bool, Never> {
        if let persistedValue = userDefaults.value(forKey: key) as? T {
            log(
                message: "ℹ️ Rewritten original value {\(persistedValue)} for key {\(key)} while persisting",
                for: .debug
            )
        }
        log(
            message: "✅ Successfully persisted value {\(String(describing: value))} for key {\(key)}",
            for: .debug
        )

        userDefaults.set(
            value,
            forKey: key
        )
        // This operation is always successful
        return Just(true).eraseToAnyPublisher()
    }

    /// Method for observing a value with given user defaults `KeyPath`.
    ///
    /// - Parameters:
    ///     - keyPath: Specified key represented by user defaults `KeyPath` value.
    @available(*, deprecated, message: "Use updated version of this method with non-optional return type")
    public func observe<T>(
        keyPath: KeyPath<UserDefaults, T?>
    ) -> AnyPublisher<T?, Never> {
        userDefaults
            .publisher(for: keyPath)
            .handleEvents(
                receiveOutput: { [weak self] value in
                    self?.log(
                        message: "✅ Observing value {\(String(describing: value))}.",
                        for: .debug
                    )
                }
            )
            .eraseToAnyPublisher()
    }

    /// Method for reading a value with given key and type.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///     - If no value is associated with key given in parameter `valueKey` or its value is nil, the method will return `noValueFound` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    @available(*, deprecated, message: "This will be removed in 2.0.0. Use the read method returning AnyPublisher<T, PersistentStorageError>", renamed: "readWithPubliser")
    public func read<T>(
        valueType: T.Type,
        valueKey: String
    ) throws -> T {
        try getPersistedValue(
            valueType: valueType,
            valueKey: valueKey
        )
    }

    /// Method for reading a value with given key and type. Result is returned as a publisher.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    @available(*, deprecated, message: "Use updated version of this method with non-optional return type")
    public func readWithPublisher<T>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T?, PersistentStorageError> {
        do {
            let persistedValue = try getPersistedOptionalValue(
                valueType: valueType,
                valueKey: valueKey
            )
            return Just(
                persistedValue
            )
            .setFailureType(to: PersistentStorageError.self)
            .eraseToAnyPublisher()
        } catch {
            guard let error = error as? PersistentStorageError else {
                return Fail(
                    error: PersistentStorageError.undefined
                ).eraseToAnyPublisher()
            }
            return Fail(
                error: error
            ).eraseToAnyPublisher()
        }
    }

    /// Method for reading a value with given key and type.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    @available(*, deprecated, message: "Use updated version of this method with non-optional return type")
    public func read<T>(
        valueType: T.Type,
        valueKey: String
    ) throws -> T? {
        try getPersistedOptionalValue(
            valueType: valueType,
            valueKey: valueKey
        )
    }

    // MARK: - Private methods

    /// TODO
    private func getPersistedOptionalValue<T>(
        valueType: T.Type,
        valueKey: String
    ) throws -> T? {
        guard let persistedValue = userDefaults.value(forKey: valueKey) as? T else {
            if userDefaults.value(forKey: valueKey) != nil {
                log(
                    message: "❌ Value with given key exists, but method is unable to parse the value with given type.",
                    for: .failure
                )
                throw PersistentStorageError.noValueFoundWithGivenType
            } else {
                log(
                    message: "ℹ️ Value with given key does not exist, returning nil.",
                    for: .failure
                )
                return nil
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
