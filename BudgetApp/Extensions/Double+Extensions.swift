//
//  Double+Extensions.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? ""
        
    }
        
}
