import Foundation

extension UserDefaults {
    convenience init?(type: UserDefaultsType) {
        switch type {
        case .standard:
            self.init()
        case .authRelated:
            self.init(suiteName: "AuthRelated")
        case let .custom(name):
            self.init(suiteName: name)
        }
    }
}
