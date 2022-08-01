//
//  Model.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import Foundation
import CoreData

enum BudgetCategoryError: Error {
    case alreadyExists
}

class Model: ObservableObject {
    
    let viewContext = CoreDataManager.shared.viewContext
    
    @Published var categories: [BudgetCategory] = []
    @Published var budgetCategory: BudgetCategory? 
    
    var total: Double {
        categories.reduce(0) { result, category in
            return category.total + result
        }
    }
    
    // add transaction to the budget
    func addTransactionToBudget(name: String, total: Double, category: BudgetCategory) throws {
        
        let transaction = Transaction(context: viewContext)
        transaction.name = name
        transaction.total = total
        transaction.dateCreated = Date()
        transaction.category = category
        
        try viewContext.save()
        
        // get all categories
        fetchBudgetCategories()
    }
    
    func budgetById(_ id: NSManagedObjectID) -> BudgetCategory? {
         viewContext.object(with: id) as? BudgetCategory
    }
    
    func addCategory(name: String, total: Double) throws {
        
        if budgetCategoryExists(name) {
            throw BudgetCategoryError.alreadyExists
        }
        
        let category = BudgetCategory(context: viewContext)
        category.name = name
        category.total = total
        category.dateCreated = Date() 
        
        // save
        try viewContext.save()
        categories.append(category)
    }
    
    private func budgetCategoryExists(_ name: String) -> Bool {
        let request = BudgetCategory.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        return ((try? viewContext.fetch(request)) ?? []).count > 0
    }
    
    func fetchBudgetCategories() {
        
        let request = BudgetCategory.fetchRequest()
        categories = (try? viewContext.fetch(request)) ?? []
        
    }
    
}
