import Foundation

extension UserDefaults {
    func codableSet<Element: Codable>(_ value: Element, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        self.set(data, forKey: key)
    }

    func codableValue<Element: Codable>(forKey key: String) -> Element? {
        guard let data = self.data(forKey: key) else {
            return nil
        }

        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}
