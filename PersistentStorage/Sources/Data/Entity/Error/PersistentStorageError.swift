import Foundation

public enum PersistentStorageError: Error {
    case noValueFound
    case noValueFoundWithGivenType
    case undefined
}
