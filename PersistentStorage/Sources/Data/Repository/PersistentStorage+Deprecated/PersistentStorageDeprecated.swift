import Combine
import Foundation

public protocol PersistentStorageDeprecated {
    /// Method for removing a value with assigned key from the user defaults storage.
    ///
    /// - Parameters:
    ///     - key: Key that will be assigned to value
    @available(*, deprecated, message: "This will be removed in 2.0.0. Use the store method that returns AnyPublisher<Void, PersistentStorageError>")
    @discardableResult
    func remove(
        valueKey: String
    ) -> AnyPublisher<Bool, Never>

    /// Method for storing a value with assigned key into the user defaults storage.
    ///
    /// - Parameters:
    ///     - value: The value you want to store in
    ///     - key: Key that will be assigned to value
    @available(*, deprecated, message: "This will be removed in 2.0.0. Use the store method that returns AnyPublisher<Void, PersistentStorageError>")
    @discardableResult
    func store<T>(
        _ value: T?,
        for key: String
    ) -> AnyPublisher<Bool, Never>

    /// Method for observing a value with given user defaults `KeyPath`.
    ///
    /// - Parameters:
    ///     - keyPath: Specified key represented by user defaults `KeyPath` value.
    @available(*, deprecated, message: "Use updated version of this method with non-optional return type")
    func observe<T>(
        keyPath: KeyPath<UserDefaults, T?>
    ) -> AnyPublisher<T?, Never>

    /// Method for reading a value with given key and type. Result is returned as a publisher.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    @available(*, deprecated, message: "Use updated version of this method with non-optional return type")
    func readWithPublisher<T>(
        valueType: T.Type,
        valueKey: String
    ) -> AnyPublisher<T?, PersistentStorageError>

    /// Method for reading a value with given key and type.
    ///
    /// - Possible failures:
    ///     - If type resolution with given parameter `valueType` fails, method will return `noValueFoundWithGivenType` failure.
    ///
    /// - Parameters:
    ///     - valueType: The type of value that you wish to read.
    ///     - valueKey: Key that is assigned to a value that you wish to read.
    @available(*, deprecated, message: "Use updated version of this method with non-optional return type")
    func read<T>(
        valueType: T.Type,
        valueKey: String
    ) throws -> T?
}
