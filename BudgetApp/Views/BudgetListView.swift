//
//  BudgetListView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 8/5/22.
//

import SwiftUI

struct BudgetListView: View {
    
    let budgetCategoryResults: FetchedResults<BudgetCategory>
    let onEdit: (BudgetCategory) -> Void
    let onDelete: (BudgetCategory) -> Void
    
    var body: some View {
        List {
            
            if !budgetCategoryResults.isEmpty {
                
                /*
                Text("Total budget \(total.formatAsCurrency())")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold) */
                
                ForEach(budgetCategoryResults) { category in
                    let _ = print("\(category.id)")
                    NavigationLink(value: Route.detail(category)) {
                        HStack {
                            Text(category.name ?? "")
                            Spacer()
                            VStack(alignment: .trailing, spacing: 10) {
                                Text(category.total.formatAsCurrency())
                                Text("\(category.overSpent ? "Overspent": "Remaining") \(category.remainingBudgetTotal.formatAsCurrency())")
                                    .fontWeight(.bold)
                                    .foregroundColor(category.overSpent ? .red: .green)
                                    .font(.caption)
                            }
                        }
                        .onLongPressGesture {
                            //sheetAction = .edit(category)
                            onEdit(category)
                        }
                    } .contentShape(Rectangle())
                }.onDelete { indexSet in
                    indexSet.map { budgetCategoryResults[$0] }.forEach(onDelete)
                }
            } else {
                Text("No budget categories found.")
            }
            
            
        }
    }
}

