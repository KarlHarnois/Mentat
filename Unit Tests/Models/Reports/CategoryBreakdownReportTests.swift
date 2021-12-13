import XCTest
@testable import Mentat

final class CategoryBreakdownReportTests: XCTestCase {
    var subject: CategoryBreakdownReport!

    let transactions: [Transaction] = [
        try! .create([
            "id": "1",
            "category": "Food",
            "subcategory": "Grocery",
            "centAmount": 5050,
            "timestamps": ["postedAt": 1638415078000]
        ]),
        try! .create([
            "id": "2",
            "category": "Food",
            "subcategory": "Grocery",
            "centAmount": 100,
            "timestamps": ["postedAt": 1638418678002]
        ]),
        try! .create([
            "id": "3",
            "category": "Food",
            "subcategory": "Restaurant",
            "isExpensed": true,
            "centAmount": 8000,
            "timestamps": ["postedAt": 1638418678001]
        ]),
        try! .create([
            "id": "4",
            "category": "Food",
            "centAmount": 100,
            "timestamps": ["postedAt": 1638677878002]
        ]),
        try! .create([
            "id": "5",
            "category": "Food",
            "centAmount": 500,
            "timestamps": ["postedAt": 1638677878001]
        ]),
        try! .create([
            "id": "6",
            "category": "Housing",
            "subcategory": "furniture",
            "centAmount": 400,
            "timestamps": ["postedAt": 1638505078004]
        ]),
        try! .create([
            "id": "7",
            "category": "Housing",
            "centAmount": 560,
            "timestamps": ["postedAt": 1638505078003]
        ]),
        try! .create([
            "id": "8",
            "centAmount": -12000,
            "timestamps": ["postedAt": 1638505078002]
        ]),
        try! .create([
            "id": "9",
            "centAmount": 1000,
            "timestamps": ["postedAt": 1638505078001]
        ]),
        try! .create([
            "id": "10",
            "centAmount": 50,
            "timestamps": ["postedAt": 1638677878000]
        ])
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

    func testSortByPostedDate() {
        let idsPerDay = subject.transactionsPerDay.mapValues { $0.map(\.id) }

        XCTAssertEqual(idsPerDay, [
            1: ["1", "3", "2"],
            2: ["9", "8", "7", "6"],
            4: ["10", "5", "4"]
        ])
    }
}
