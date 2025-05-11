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
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack(spacing: 30) {
                Text("New Transaction")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("$")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                TextField("0", text: $amount)
                    .keyboardType(.decimalPad)
                Text("Category")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                TextField("", text: $category)
                    .keyboardType(.default)
                    .background(.gray.opacity(0.2))
                Button(action: {
                    print("Button was tapped!")
                }) {
                    Text("Save")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            }
        }
    }
}


//#Preview {
//    AddTransaction(appManager: AppManager(), appData: AppDataManager())
//}



