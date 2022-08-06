//
//  ContentView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI

enum SheetAction: Identifiable {
    
    var id: UUID {
        UUID()
    }
    
    case add
    case edit(BudgetCategory)
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: BudgetCategory.all) var budgetCategoryResults
    @State private var sheetAction: SheetAction?
    
    private func deleteBudgetCategory(_ indexSet: IndexSet) {
        
        guard let index = indexSet.first else { return }
        let budget = budgetCategoryResults[index]
        viewContext.delete(budget)
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    var total: Double {
        budgetCategoryResults.reduce(0) { result, budgetCategory in
            return result + budgetCategory.total
        }
    }
  
    var body: some View {
        let _ = print(Self._printChanges())
        List {
            
            if !budgetCategoryResults.isEmpty {
                
                Text("Total budget \(total.formatAsCurrency())")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
                
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
                            sheetAction = .edit(category)
                        }
                    } .contentShape(Rectangle())
                }.onDelete(perform: deleteBudgetCategory)
            } else {
                Text("No budget categories found.")
            }
            
            
        }
        .listStyle(.plain)
        .sheet(item: $sheetAction, content: { sheetAction in
            switch sheetAction {
                case .add:
                    AddBudgetCategoryView()
                case .edit(let category):
                    AddBudgetCategoryView(budgetCategoryToEdit: category)
            }
        })
        .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Budget")
                        .font(.largeTitle)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                   
                    Button("Add Category") {
                        sheetAction = .add
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView().environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        }
    }
}
