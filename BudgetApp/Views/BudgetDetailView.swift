//
//  BudgetDetailView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI

struct BudgetDetailView: View {
    
    @EnvironmentObject private var model: Model
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
                try model.addTransactionToBudget(name: name, total: Double(total)!, category: budgetCategory)
                // clear fields
                name = ""
                total = ""
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
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
            
            if let transactions = budgetCategory.transactions {
                let allTransactions = (transactions.allObjects as? [Transaction]) ?? []
                if allTransactions.isEmpty {
                    Text("No transactions.")
                } else {
                    List {
                        BudgetSummaryView()
                        TransactionListView(transactions: allTransactions)
                    }
                }
            }
            
            Spacer()
            
        }.padding()
            .onAppear {
                model.budgetCategory = budgetCategory
            }
    }
}

struct BudgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetDetailView(budgetCategory: BudgetCategory.preview).environmentObject(Model())
    }
}
