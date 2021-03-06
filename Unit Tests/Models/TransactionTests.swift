import XCTest
@testable import Mentat

final class TransationTests: XCTestCase {
    func testIsPersonalExpense() {
        let expense = Transaction.create(centAmount: 5000, isExpensed: false)
        let expensedExpense = Transaction.create(centAmount: 100, isExpensed: true)
        let deposit = Transaction.create(centAmount: -5000)

        XCTAssertEqual([expense, expensedExpense, deposit].map(\.isPersonalExpense), [true, false, false])
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
        let transaction = Transaction.create(category: .food)
        XCTAssertEqual(try encode(transaction)?["category"] as? String, "Food")
    }

    func testEncodingSubcategory() {
        let transaction = Transaction.create(subcategory: .grocery)
        XCTAssertEqual(try encode(transaction)?["subcategory"] as? String, "Grocery")
    }

    func testDateEncodingAndDecoding() throws {
        let transaction = try decodeTransaction()
        let encodedTransaction = try encode(transaction)
        let encodedTimestamps = encodedTransaction?["timestamps"] as? [String: Any]
        XCTAssertEqual(encodedTimestamps?["postedAt"] as? Int, 1620172800000)
    }

    func testSortedByDay() {
        let transactions: [Transaction] = [
            .create(id: "1", timestamps: .create(
                authorizedAt: .init(day: 4, month: .december, year: 2021).flatMap { $0.adding(minutes: 2) }!
            )),
            .create(id: "2", timestamps: .create(
                authorizedAt: .init(day: 4, month: .december, year: 2021).flatMap { $0.adding(minutes: 5) }!
            )),
            .create(id: "3", timestamps: .create(
                authorizedAt: .init(day: 7, month: .december, year: 2021)!
            )),
            .create(id: "4", timestamps: .create(
                authorizedAt: .init(day: 4, month: .december, year: 2021)!
            ))
        ]

        let idsPerDay = transactions.sortedByDay().mapValues { $0.map(\.id) }
        XCTAssertEqual(idsPerDay, [4: ["4", "1", "2"], 7: ["3"]])
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
