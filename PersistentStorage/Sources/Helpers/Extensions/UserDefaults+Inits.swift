import Foundation

extension UserDefaults {
    convenience init?(type: UserDefaultsType) {
        self.init(suiteName: type.name)
    }
}
