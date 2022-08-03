//
//  BudgetSummaryView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/31/22.
//

import SwiftUI

struct BudgetSummaryView: View {
    
    @ObservedObject var budgetCategory: BudgetCategory
    
    var body: some View {
        let _ = print(Self._printChanges())
        VStack {
            
            Text("\(budgetCategory.overSpent ? "Overspent": "Remaining") \(budgetCategory.remainingBudgetTotal.formatAsCurrency())")
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)
                .foregroundColor(budgetCategory.overSpent ? .red: .green)
            
        }
    }
}


struct BudgetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetSummaryView(budgetCategory: BudgetCategory.preview)
    }
}
