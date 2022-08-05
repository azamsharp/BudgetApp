//
//  BudgetCategory.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import Foundation
import CoreData


@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    public override func awakeFromInsert() {
        self.dateCreated = Date() 
    }
    
    // for preview
    static var preview: BudgetCategory {
        BudgetCategory()
    }
    
    static func exists(_ name: String) -> Bool {
        let vc = CoreDataProvider.shared.viewContext
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "name == %@", name)
        return ((try? vc.fetch(request)) ?? []).count > 0
    }
    
    static var all: NSFetchRequest<BudgetCategory> {
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }
    
    static var `default`: BudgetCategory {
        return BudgetCategory()
    }
    
    var overSpent: Bool {
        remainingBudgetTotal < 0 
    }
    
    var transactionsTotal: Double {
        return transactionsArray.reduce(0) { result, transaction in
            result + transaction.total
        }
    }
    
    var remainingBudgetTotal: Double {
        self.total - transactionsTotal
    }
    
    private var transactionsArray: [Transaction] {

        guard let transactions = transactions else { return [] }
        let allTransactions = (transactions.allObjects as? [Transaction]) ?? []
        return allTransactions.sorted { t1, t2 in
            t1.dateCreated! > t2.dateCreated!
        } 
    }
    
    static func transactionByCategoryRequest(_ budgetCategory: BudgetCategory) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        return request
    }
    
    lazy var transactionByCategoryRequest: NSFetchRequest<Transaction> = {
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "category = %@", self)
        return request
    }()

}
