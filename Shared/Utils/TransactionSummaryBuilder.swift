struct TransactionSummaryBuilder {
    private typealias Sections = [Category: CategoryTransactionSummary]
    private typealias Subsections = [Category: [Subcategory: SubcategoryTransactionSummary]]

    func summary(for transactions: [Transaction]) -> TransactionSummary {
        var summary = TransactionSummary(transactions: transactions)
        var sections: Sections = [:]
        var subSections: Subsections = [:]

        transactions.forEach { transaction in
            let total = transaction.centAmount
            summary.total += total

            if transaction.isPersonalExpense {
                summary.expenseTotal += total
            }

            guard let category = transaction.category else {
                if transaction.isPersonalExpense {
                    summary.uncategorizedExpenseTotal += total
                }
                return
            }

            var section = findOrCreateSection(for: category, in: sections)
            assign(transaction, to: &section)
            sections[category] = section

            guard let subcategory = transaction.subcategory else { return }
            createSubsectionsIfNeeded(in: &subSections, for: category)
            var subsection = findOrCreateSubsection(for: category, and: subcategory, in: subSections)
            assign(transaction, to: &subsection)
            subSections[category]?[subcategory] = subsection
        }

        summary.categorySections = categorySummaries(from: sections, and: subSections)
        return summary
    }

    private func findOrCreateSection(for category: Category, in sections: Sections) -> CategoryTransactionSummary {
        guard let section = sections[category] else {
            return CategoryTransactionSummary(category: category)
        }
        return section
    }

    private func findOrCreateSubsection(for category: Category, and subcategory: Subcategory, in subsections: Subsections) -> SubcategoryTransactionSummary {
        guard let section = subsections[category]?[subcategory] else {
            return SubcategoryTransactionSummary(subcategory: subcategory)
        }
        return section
    }

    private func createSubsectionsIfNeeded(in subsections: inout Subsections, for category: Category) {
        if subsections[category] == nil {
            subsections[category] = [:]
        }
    }

    private func assign(_ transaction: Transaction, to summary: inout CategoryTransactionSummary) {
        summary.total += transaction.centAmount
        summary.transactions.append(transaction)

        if transaction.subcategory == nil {
            summary.uncategorizedTotal += transaction.centAmount
        }
    }

    private func assign(_ transaction: Transaction, to summary: inout SubcategoryTransactionSummary) {
        summary.total += transaction.centAmount
        summary.transactions.append(transaction)
    }

    private func categorySummaries(from sections: Sections, and subsections: Subsections) -> [CategoryTransactionSummary] {
        sections.map { category, section in
            var copy = section
            copy.subcategories = subsections[category]?.map { _, value in value } ?? []
            return copy
        }
    }
}
