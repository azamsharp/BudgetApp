//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI

enum Route: Hashable {
    case detail(BudgetCategory)
}

@main
struct BudgetAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .navigationDestination(for: Route.self, destination: { route in
                        switch route {
                        case .detail(let budgetCategory):
                            BudgetDetailView(budgetCategory: budgetCategory)
                        }
                    })
            }
            .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        }
    }
}
