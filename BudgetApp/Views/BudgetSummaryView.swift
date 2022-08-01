//
//  BudgetSummaryView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/31/22.
//

import SwiftUI

struct BudgetSummaryView: View {
    
    @EnvironmentObject private var model: Model
    
    var body: some View {
        VStack {
            
            if let budgetCategory = model.budgetCategory {
                Text("Total \(budgetCategory.transactionsTotal.formatAsCurrency())")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)

                Text("\(budgetCategory.overSpent ? "Overspent": "Remaining") \(budgetCategory.remainingBudgetTotal.formatAsCurrency())")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
                    .foregroundColor(budgetCategory.overSpent ? .red: .green)
            }
            
           
        }
    }
}


struct BudgetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetSummaryView()
    }
}
