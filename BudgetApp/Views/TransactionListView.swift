//
//  TransactionListView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/31/22.
//

import SwiftUI

struct TransactionListView: View {
    
    let transactions: [Transaction]
    
    var body: some View {
        ForEach(transactions) { item in
            HStack {
                Text(item.name ?? "")
                Spacer()
                Text(item.total.formatAsCurrency())
            }
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(transactions: [])
    }
}
