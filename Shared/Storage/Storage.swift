import Foundation

protocol Storage {
    func data(forKey key: String) -> Data?
    func save(_ data: Data, forKey key: String)
}

extension UserDefaults: Storage {
    func save(_ data: Data, forKey key: String) {
        set(data, forKey: key)
    }
}
