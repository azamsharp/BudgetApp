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
        let model = Model()
        model.fetchBudgetCategories()
        return model.categories[0]
    }
    
    static func exists(_ name: String) -> Bool {
        let vc = CoreDataManager.shared.viewContext
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
    
    var transactionsArray: [Transaction] {

        guard let transactions = transactions else { return [] }
        let allTransactions = (transactions.allObjects as? [Transaction]) ?? []
        //return allTransactions
        
        return allTransactions.sorted { t1, t2 in
            t1.dateCreated! > t2.dateCreated!
        } 
    }
    
    lazy var transactionsFetchRequest: NSFetchRequest<Transaction> = {
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "category = %@", self)
        return request
    }()

}
