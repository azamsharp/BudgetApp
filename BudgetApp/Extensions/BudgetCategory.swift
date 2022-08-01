//
//  BudgetCategory.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import Foundation

// for previews
extension BudgetCategory {
    
    static var preview: BudgetCategory {
        let model = Model()
        model.fetchBudgetCategories()
        return model.categories[0]
    }
    
    static var `default`: BudgetCategory {
        return BudgetCategory()
    }
    
    var overSpent: Bool {
        remainingBudgetTotal < transactionsTotal 
    }
    
    var transactionsTotal: Double {
        guard let transactions = transactions?.allObjects as? [Transaction] else { return 0.0 }
        return transactions.reduce(0) { result, transaction in
            result + transaction.total
        }
    }
    
    var remainingBudgetTotal: Double {
        self.total - transactionsTotal
    }

}
