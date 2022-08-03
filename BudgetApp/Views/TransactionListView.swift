//
//  TransactionListView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/31/22.
//

import SwiftUI
import CoreData 

struct TransactionListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let fetchRequest: FetchRequest<Transaction>
    private var transactions: FetchedResults<Transaction> {
        return fetchRequest.wrappedValue
    }
    let onDelete: (Transaction) -> Void
    
    private func deleteTransaction(at indexSet: IndexSet) {
        
        guard let indexToDelete = indexSet.first else { return }
        let transaction = transactions[indexToDelete]
        print(transaction) // sometimes this displays a fault object for some elements.
        print(transaction.objectID) // objectID always exists
        
        print("delete Transaction")
        print(transaction.total.formatAsCurrency())
        
        onDelete(transaction)
    }
    
    var body: some View {
        let _ = print(Self._printChanges())
        
        if transactions.isEmpty {
            Text("No transactions.")
        } else {
            List {
                ForEach(transactions) { transaction in
                    HStack {
                        Text(transaction.name ?? "")
                        Spacer()
                        Text(transaction.total.formatAsCurrency())
                    }
                }.onDelete(perform: deleteTransaction)
            }
        }
        
        
    }
}

