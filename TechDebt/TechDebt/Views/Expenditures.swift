//
//  Expenditures.swift
//  TechDebt
//
//  Created by Julian Ignacio Macaraig Alcazaren on 5/9/25.
//

import SwiftUI

struct AddTransaction: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager
    
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var isFormValid: Bool = true
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack(spacing: 50) {
                Text("New Transaction")
                    .font(.system(size: 40, weight: .bold) )
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("$")
                        .font(.system(size: 40, weight: .bold))
                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .frame(width: 100)
                }

                
                HStack(spacing: 20) {
                    Text("Category")
                        .font(.system(size: 25, weight: .semibold))
                    TextField("", text: $category)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .frame(width: 160)
                }


                Button(action: {
                    print("Button tapped")
                }) {
                    Text("Save")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isFormValid ? Color.black : Color.gray)
                        .cornerRadius(20)
                        .padding(.horizontal, 50)
                }
                .disabled(!isFormValid) // disables the button when form is invalid
                
            }
        }
    }
}

//
//#Preview {
//    AddTransaction(appManager: AppManager(), appData: AppDataManager())
//}



