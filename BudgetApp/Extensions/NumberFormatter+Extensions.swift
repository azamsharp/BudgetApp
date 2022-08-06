//
//  NumberFormatter+Extensions.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 8/6/22.
//

import Foundation

extension NumberFormatter {
    
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
}
