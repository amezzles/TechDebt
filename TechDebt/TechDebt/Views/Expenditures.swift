//
//  Expenditures.swift
//  TechDebt
//
import SwiftUI

struct AddTransaction: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

    @State private var amount: String = ""

    var isFormValid: Bool {
        if let val = Float(amount), val > 0 {
            return true
        }
        return false
    }

    private func saveTransaction() {
        _ = appData.SetBudgetRemainingAfterTransaction(stringVal: amount)
        amount = ""
    }

    func CloseSettings() {
        appManager.menuState = .mainMenu
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer().frame(height: 60) // Space below the close button

                Text("New Transaction")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("$")
                        .font(.system(size: 40, weight: .bold))
                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .frame(width: 120)
                }

                Button(action: {
                    print("Button tapped")
                    saveTransaction()
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
                .disabled(!isFormValid)
                
                Spacer()
            }
            .padding(.top, 20)

            // Top-left Close button
            Button(action: CloseSettings) {
                Text("Close")
                    .font(.system(size: 18))
                    .padding()
            }
        }
    }
}


//#Preview {
 //AddTransaction(appManager: AppManager(), appData: AppDataManager())
//}


