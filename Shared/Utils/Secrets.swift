import Foundation

enum Secrets: String {
    case transactionServiceBaseURL = "TRANSACTION_SERVICE_BASE_URL"
    case transactionServiceApiKey = "TRANSACTION_SERVICE_API_KEY"

    var key: String {
        rawValue
    }

    func read() throws -> String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            throw "Could not find Secrets.plist"
        }
        guard let secrets = NSDictionary(contentsOfFile: path) else {
            throw "Could not create \(NSDictionary.self) from Secrets.plist"
        }
        guard let secretValue = secrets[key] else {
            throw "Could not find secret value for key \(key)"
        }
        guard let result = secretValue as? String else {
            throw "Could not cast \(secretValue) for key \(key) to type \(String.self)"
        }
        return result
    }
}
