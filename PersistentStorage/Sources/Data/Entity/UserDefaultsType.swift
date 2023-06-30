import Foundation

public enum UserDefaultsType {
    case standard
    case authRelated
    case custom(String)

    var name: String? {
        switch self {
        case .standard:
            return nil
        case .authRelated:
            return "authRelated"
        case let .custom(name):
            return "custom_\(name)"
        }
    }
}
