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
    
    @StateObject private var model: Model = Model()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                   
            }//.environmentObject(model)
            .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
        }
    }
}
