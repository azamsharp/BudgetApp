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

// AGGREGATE ROOT
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
    
    func budgetById(_ id: NSManagedObjectID) throws -> BudgetCategory  {
        
        guard let budgetCategory = try viewContext.existingObject(with: id) as? BudgetCategory else {
            fatalError("Budget Category does not exist")
        }
        
        return budgetCategory 
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
    
    func deleteBudgetCategory(_ budgetCategory: BudgetCategory) throws {
        viewContext.delete(budgetCategory)
        try viewContext.save()
    }
    
    private func budgetCategoryExists(_ name: String) -> Bool {
        let request = BudgetCategory.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        return ((try? viewContext.fetch(request)) ?? []).count > 0
    }
    
    func fetchBudgetCategories() {
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        categories = (try? viewContext.fetch(request)) ?? []
    }
    
    func removeTransactionById(_ id: NSManagedObjectID) throws {
        
        let transaction = try viewContext.existingObject(with: id)
        viewContext.delete(transaction)
        try viewContext.save()
        
    }
    
    func removeTransaction(_ transaction: Transaction) throws {
        
        let transaction = try viewContext.existingObject(with: transaction.objectID)
        viewContext.delete(transaction)
        try viewContext.save()
    }
    
    func removeTransactionFromBudget(budget: BudgetCategory, transaction: Transaction) throws {
        budget.removeFromTransactions(transaction)
        try viewContext.save()
    }
    
}
