//
//  AddBudgetCategoryView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI

struct AddBudgetCategoryView: View {
    
    @EnvironmentObject private var model: Model
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var total: Double = 100
    @State private var messages: [String] = []
    
    private func saveBudgetCategory() {
        
        messages = []
        
        // validate the form
        if isFormValid {
            do {
                try model.addCategory(name: name, total: total)
                dismiss()
            } catch BudgetCategoryError.alreadyExists {
                messages.append("Category already exists.")
            }
            catch {
                messages.append(error.localizedDescription)
            }
        }
    }
    
    var isFormValid: Bool {
        
        if name.isEmpty {
            messages.append("Name is required")
        }
        
        if total <= 0 {
            messages.append("Total should be greater than 1.")
        }
        
        return messages.count == 0
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Slider(value: $total, in: 0...500, step: 50) {
                    Text("Total")
                } minimumValueLabel: {
                    Text("$0")
                } maximumValueLabel: {
                    Text("$500")
                }
                Text(total.formatAsCurrency())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ForEach(messages, id: \.self) { message in
                    Text(message)
                }
                
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBudgetCategory()
                    }
                }
            }
        }
        
        
    }
}

struct AddBudgetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBudgetCategoryView()
        }
    }
}
