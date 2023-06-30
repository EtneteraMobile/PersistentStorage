import Foundation

public enum PersistentStorageError: Error {
    case cannotCreateUserDefaults
    case noValueFound
    case noValueFoundWithGivenType
    case undefined
}
