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
    
    var total: Double {
        budgetCategoryResults.reduce(0) { result, budgetCategory in
            return result + budgetCategory.total
        }
    }
  
    var body: some View {
        let _ = print(Self._printChanges())
        
        BudgetListView(budgetCategoryResults: budgetCategoryResults) { category in
            sheetAction = .edit(category)
        } onDelete: { category in
            viewContext.delete(category)
            do {
                try viewContext.save()
            } catch {
                print(error)
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
