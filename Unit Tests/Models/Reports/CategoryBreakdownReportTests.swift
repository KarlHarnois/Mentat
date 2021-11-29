import XCTest
@testable import Mentat

final class CategoryBreakdownReportTests: XCTestCase {
    var subject: CategoryBreakdownReport!

    let transactions: [Transaction] = [
        try! .create(["category": "Food", "subcategory": "Grocery", "centAmount": 5050]),
        try! .create(["category": "Food", "subcategory": "Grocery", "centAmount": 100]),
        try! .create(["category": "Food", "subcategory": "Restaurant", "isExpensed": true, "centAmount": 8000]),
        try! .create(["category": "Food", "centAmount": 100]),
        try! .create(["category": "Food", "centAmount": 500]),
        try! .create(["category": "Housing", "subcategory": "furniture", "centAmount": 400]),
        try! .create(["category": "Housing", "centAmount": 560]),
        try! .create(["centAmount": -12000]),
        try! .create(["centAmount": 1000]),
        try! .create(["centAmount": 50])
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
