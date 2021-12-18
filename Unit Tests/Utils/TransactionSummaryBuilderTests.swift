import XCTest
@testable import Mentat

final class TransactionSummaryBuilderTests: XCTestCase {
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

    lazy var summary: TransactionSummary = {
        let builder = TransactionSummaryBuilder()
        return builder.summary(for: transactions)
    }()

    func testTransactions() {
        XCTAssertEqual(summary.transactions, transactions)
    }

    func testTotal() {
        XCTAssertEqual(summary.total, 3760)
    }

    func testExpenseTotal() {
        XCTAssertEqual(summary.expenseTotal, 7760)
    }

    func testUncategorizedExpenseTotal() {
        XCTAssertEqual(summary.uncategorizedExpenseTotal, 1050)
    }

    func testTotalPerCategory() {
        XCTAssertEqual(categoryDictionary(\.total), [.food: 13750, .housing: 960])
    }

    func testUncategorizedTotalByCategory() {
        XCTAssertEqual(categoryDictionary(\.uncategorizedTotal), [.food: 600, .housing: 560])
    }

    func testCategoryTransactions() {
        XCTAssertEqual(categoryDictionary(\.transactions).mapValues { $0.map(\.id) }, [
            .food: ["1", "2", "3", "4", "5"],
            .housing: ["6", "7"]
        ])
    }

    func testTotalPerSubcategory() {
        XCTAssertEqual(subcategoryDictionary(.food, \.total), [.grocery: 5150, .restaurant: 8000])
        XCTAssertEqual(subcategoryDictionary(.housing, \.total), [.furniture: 400])
    }

    func testSubcategoryransactions() {
        XCTAssertEqual(subcategoryDictionary(.food, \.transactions).mapValues { $0.map(\.id) }, [
            .grocery: ["1", "2"],
            .restaurant: ["3"]
        ])
    }

    private func categoryDictionary<T>(_ keyPath: KeyPath<CategoryTransactionSummary, T>) -> [Mentat.Category: T] {
        Dictionary(uniqueKeysWithValues: summary.categorySections.map {
            ($0.category, $0[keyPath: keyPath])
        })
    }

    private func subcategoryDictionary<T>(_ category: Mentat.Category, _ keyPath: KeyPath<SubcategoryTransactionSummary, T>) -> [Mentat.Subcategory: T] {
        guard let section = summary.categorySections.first(where: { $0.category == category }) else {
            return [:]
        }
        return Dictionary(uniqueKeysWithValues: section.subcategories.map {
            ($0.subcategory, $0[keyPath: keyPath])
        })
    }
}
