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
            return "AuthRelated_\(Bundle.main.bundleIdentifier ?? "")"
        case let .custom(name):
            return "Custom_\(name)_\(Bundle.main.bundleIdentifier ?? "")"
        }
    }
}
