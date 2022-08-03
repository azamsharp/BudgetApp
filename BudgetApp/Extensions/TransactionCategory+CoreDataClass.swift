//
//  TransactionCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 8/3/22.
//

import Foundation
import CoreData


@objc(Transaction)
public class Transaction: NSManagedObject {
 
    public override func awakeFromInsert() {
        self.dateCreated = Date() 
    }
}
