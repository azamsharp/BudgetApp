//
//  BudgetDetailView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI

struct BudgetDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let budgetCategory: BudgetCategory
    @State private var name: String = ""
    @State private var total: String = ""
    
    var isFormValid: Bool {
        
        guard let totalAsDouble = Double(total) else { return false }
        return !name.isEmpty && !total.isEmpty && totalAsDouble > 0
    }
    
    private func saveTransaction() {
        if isFormValid {
            do {
                
                let transaction = Transaction(context: viewContext)
                transaction.name = name
                transaction.total = Double(total)!
                
                budgetCategory.addToTransactions(transaction)
                try viewContext.save()
                
                name = ""
                total = ""
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        let _ = print(Self._printChanges())
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading) {
                    Text(budgetCategory.name ?? "")
                        .font(.largeTitle)
                    Text("Budget: \(budgetCategory.total.formatAsCurrency())")
                        .fontWeight(.bold)
                }
                Spacer()
            }
            
            Form {
                Section(header: Text("Add Transaction")) {
                    TextField("Name", text: $name)
                    TextField("Total", text: $total)
                    
                    Button {
                        // action
                        saveTransaction()
                    } label: {
                        Text("Save Transaction")
                            .frame(maxWidth: .infinity)
                    }.disabled(!isFormValid)
                    
                }
            }.frame(maxHeight: 200)
            
            BudgetSummaryView(budgetCategory: budgetCategory)
            
            if budgetCategory.transactions?.count == 0 {
                Text("No transactions.")
                    .padding([.top], 20)
            } else {
                    TransactionListView(request: BudgetCategory.transactionByCategoryRequest(budgetCategory), onDelete: deleteTransaction)
            }
           
            Spacer()
            
        }.padding()
    }
}

struct BudgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetDetailView(budgetCategory: BudgetCategory.preview)
    }
}
