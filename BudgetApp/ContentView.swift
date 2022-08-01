//
//  ContentView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    @EnvironmentObject private var model: Model
    
    var body: some View {
        List {
            
            if !model.categories.isEmpty {
                Text("Total budget \(model.total.formatAsCurrency())")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
                
                ForEach(model.categories) { category in
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
                    }
                }
            } else {
                Text("No budget categories found.")
            }
            
            
        }
        .task {
            model.fetchBudgetCategories()
        }
        .listStyle(.plain)
        .sheet(isPresented: $isPresented, content: {
            AddBudgetCategoryView()
        })
       // .navigationTitle("Budget")
        
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Budget")
                        .font(.largeTitle)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                   
                    Button("Add Category") {
                        isPresented = true
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                        case .detail(let budget):
                            BudgetDetailView(budgetCategory: budget)
                    }
                }
        }.environmentObject(Model())
    }
}
