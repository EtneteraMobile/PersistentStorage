import Foundation

extension UserDefaults {
    convenience init?(type: UserDefaultsType) {
        switch type {
        case .standard:
            self.init()
        case .authRelated:
            self.init(suiteName: Bundle.main.bundleIdentifier ?? "" + "authRelated")
        case let .custom(name):
            self.init(suiteName: Bundle.main.bundleIdentifier ?? "" + name)
        }
    }
}
