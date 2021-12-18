struct TransactionSummaryBuilder {
    func summary(for transactions: [Transaction]) -> TransactionSummary {
        var summary = TransactionSummary(transactions: transactions)
        var categorySections: [Category: CategoryTransactionSummary] = [:]
        var subcategorySections: [Category: [Subcategory: SubcategoryTransactionSummary]] = [:]

        transactions.forEach { transaction in
            summary.total += transaction.centAmount

            if transaction.isPersonalExpense {
                summary.expenseTotal += transaction.centAmount
            }

            guard let category = transaction.category else {
                if transaction.isPersonalExpense {
                    summary.uncategorizedExpenseTotal += transaction.centAmount
                }
                return
            }

            if subcategorySections[category] == nil {
                subcategorySections[category] = [:]
            }

            var section = findOrCreateSection(for: category, in: categorySections)
            section.total += transaction.centAmount
            section.transactions.append(transaction)

            if transaction.subcategory == nil {
                section.uncategorizedTotal += transaction.centAmount
            }

            categorySections[category] = section

            guard let subcategory = transaction.subcategory else {
                return
            }

            var subsection = findOrCreateSubsection(for: category, and: subcategory, in: subcategorySections)
            subsection.total += transaction.centAmount
            subsection.transactions.append(transaction)
            subcategorySections[category]?[subcategory] = subsection
        }

        summary.categorySections = categorySections.map { category, section in
            var copy = section
            copy.subcategories = subcategorySections[category]?.map { _, value in value } ?? []
            return copy
        }
        return summary
    }

    private func findOrCreateSection(for category: Category, in dictionary: [Category: CategoryTransactionSummary]) -> CategoryTransactionSummary {
        guard let section = dictionary[category] else {
            return CategoryTransactionSummary(category: category)
        }
        return section
    }

    private func findOrCreateSubsection(for category: Category, and subcategory: Subcategory, in dictionary: [Category: [Subcategory: SubcategoryTransactionSummary]]) -> SubcategoryTransactionSummary {
        guard let section = dictionary[category]?[subcategory] else {
            return SubcategoryTransactionSummary(subcategory: subcategory)
        }
        return section
    }
}
