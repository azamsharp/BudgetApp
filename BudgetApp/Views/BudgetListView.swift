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
                
                ForEach(budgetCategoryResults) { category in
                    let _ = print("\(category.id)")
                    NavigationLink(value: Route.detail(category)) {
                        HStack {
                            Text(category.name ?? "")
                            Spacer()
                            VStack(alignment: .trailing, spacing: 10) {
                                Text(category.total as NSNumber, formatter: NumberFormatter.currency)
                                Text("\(category.overSpent ? "Overspent": "Remaining") \(category.remainingBudgetTotal.formatAsCurrency())")
                                    .fontWeight(.bold)
                                    .foregroundColor(category.overSpent ? .red: .green)
                                    .font(.caption)
                            }
                        }
                        .contentShape(Rectangle())
                        .onLongPressGesture {
                            onEdit(category)
                        }
                    }
                }.onDelete { indexSet in
                    indexSet.map { budgetCategoryResults[$0] }.forEach(onDelete)
                }
            } else {
                Text("No budget categories found.")
            }
            
            
        }
    }
}

