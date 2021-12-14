import XCTest
@testable import Mentat

final class CategoryBreakdownReportTests: XCTestCase {
    var subject: CategoryBreakdownReport!

    let transactions: [Transaction] = [
        .create(id: "1", category: .food, subcategory: .grocery, centAmount: 5050),
        .create(id: "2", category: .food, subcategory: .grocery, centAmount: 100),
        .create(id: "3", category: .food, subcategory: .restaurant, centAmount: 8000, isExpensed: true),
        .create(id: "4", category: .food, centAmount: 100),
        .create(id: "5", category: .food, centAmount: 500),
        .create(id: "6", category: .housing, subcategory: .furniture, centAmount: 400),
        .create(id: "7", category: .housing, centAmount: 560),
        .create(id: "8", centAmount: -12000),
        .create(id: "9", centAmount: 1000),
        .create(id: "10", centAmount: 50)
    ]

    override func setUp() {
        subject = .init(transactions: transactions)
    }

    func testTransactions() {
        XCTAssertEqual(subject.transactions, transactions)
    }

    func testTotal() {
        XCTAssertEqual(subject.total, 3760)
    }

    func testExpenseTotal() {
        XCTAssertEqual(subject.expenseTotal, 7760)
    }

    func testUncategorizedExpenseTotal() {
        XCTAssertEqual(subject.uncategorizedExpenseTotal, 1050)
    }

    func testTotalPerCategory() {
        XCTAssertEqual(subject.totalPerCategory, [.food: 13750, .housing: 960])
    }

    func testUncategorizedTotalByCategory() {
        XCTAssertEqual(subject.uncategorizedTotalByCategory[.food], 600)
    }

    func testTotalPerSubcategory() {
        XCTAssertEqual(subject.totalPerSubcategory, [
            .food: [
                .grocery: 5150,
                .restaurant: 8000
            ],
            .housing: [
                .furniture: 400
            ]
        ])
    }
}
