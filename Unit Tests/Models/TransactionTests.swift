import XCTest
@testable import Mentat

final class TransationTests: XCTestCase {
    var transaction: Transaction!

    override func setUp() {
        transaction = .init(
            id: "1234",
            description: "some grocery",
            fullDescription: "SOME GROCERY",
            category: .food,
            subcategory: .grocery,
            centAmount: 5000,
            currency: .usd,
            currencyCentAmount: 3916,
            source: .init(name: "Visa", last4: "4242"),
            isExpensed: false,
            timestamps: .init(
                createdAt: nil,
                updatedAt: nil,
                postedAt: .init(),
                deletedAt: nil,
                authorizedAt: nil
            )
        )
    }

    func testDecodingId() throws {
        XCTAssertEqual(try decodeTransaction().id, "1234")
    }

    func testDecodingCentAmount() throws {
        XCTAssertEqual(try decodeTransaction().centAmount, 1550)
    }

    func testDecodingCurrencyCentAmount() throws {
        XCTAssertEqual(try decodeTransaction().currencyCentAmount, 1550)
    }

    func testDecodingCurrency() throws {
        XCTAssertEqual(try decodeTransaction().currency, .cad)
    }

    func testDecodingDescription() throws {
        XCTAssertEqual(try decodeTransaction().description, "Best Coffeeshop Ever")
    }

    func testDecodingFullDescription() {
        XCTAssertEqual(try decodeTransaction().fullDescription, "BEST COFFEESHOP EVER")
    }

    func testDecodingSource() {
        XCTAssertEqual(try decodeTransaction().source, TransactionSource(name: "Visa", last4: "4242"))
    }

    func testDecodingCategory() {
        XCTAssertEqual(try decodeTransaction().category, .food)
    }

    func testDecodingSubcategory() {
        XCTAssertEqual(try decodeTransaction().subcategory, .coffee)
    }

    func testDecodingIsExpensed() {
        XCTAssertEqual(try decodeTransaction().isExpensed, false)
    }

    func testDecodingDates() throws {
        let date = try decodeTransaction().timestamps.postedAt
        let components = Calendar.current.dateComponents([.month, .year], from: date)
        XCTAssertEqual(components.month, 5)
        XCTAssertEqual(components.year, 2021)
    }

    func testEncodingCategory() {
        XCTAssertEqual(try encode(transaction)?["category"] as? String, "Food")
    }

    func testEncodingSubcategory() {
        XCTAssertEqual(try encode(transaction)?["subcategory"] as? String, "Grocery")
    }

    func testDateEncodingAndDecoding() throws {
        let transaction = try decodeTransaction()
        let encodedTransaction = try encode(transaction)
        let encodedTimestamps = encodedTransaction?["timestamps"] as? [String: Any]
        XCTAssertEqual(encodedTimestamps?["postedAt"] as? Int, 1620172800000)
    }

    private func decodeTransaction() throws -> Transaction {
        let json = """
        {
            "centAmount": 1550,
            "currency": "CAD",
            "currencyCentAmount": 1550,
            "description": "Best Coffeeshop Ever",
            "fullDescription": "BEST COFFEESHOP EVER",
            "category": "Food",
            "subcategory": "Coffee",
            "id": "1234",
            "isExpensed": false,
            "source": {
                "last4": "4242",
                "name": "Visa"
            },
            "timestamps": {
                "authorizedAt": 1620175727000,
                "createdAt": 1638165004910,
                "postedAt": 1620172800000,
                "updatedAt": 1638165004910
            }
        }
        """

        guard let json = json.data(using: .utf8) else {
            throw "Could not encode JSON fixture."
        }
        let decoder = JSONDecoder.custom
        return try decoder.decode(Transaction.self, from: json)
    }

    private func encode(_ transaction: Transaction) throws -> [String: Any]? {
        let encoder = JSONEncoder.custom
        let data = try encoder.encode(transaction)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        return object as? [String: Any]
    }
}
