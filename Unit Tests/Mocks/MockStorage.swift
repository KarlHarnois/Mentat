import Foundation
@testable import Mentat

final class MockStorage: Storage {
    var data = [String: Data]()

    func data(forKey key: String) -> Data? {
        data[key]
    }

    func save(_ data: Data, forKey key: String) {
        self.data[key] = data
    }
}
