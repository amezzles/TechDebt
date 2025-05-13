import SwiftUI

struct AddTransaction: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager
    // REMOVED: @Environment(\.appTheme) var theme

    @State private var amount: String = ""

    var isFormValid: Bool {
        ConvertValue.CurrencyToFloat(stringVal: amount) > 0
    }

    private func saveTransaction() {
        _ = appData.SetBudgetRemainingAfterTransaction(stringVal: amount)
        amount = ""
        CloseSettings()
    }

    func CloseSettings() {
        hideKeyboard()
        appManager.menuState = .mainMenu
    }

     private func hideKeyboard() {
         UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Use static background color
            StaticAppColors.primaryBackground.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer().frame(height: 60)

                Text("New Transaction")
                    .font(StaticAppFonts.largeTitle) // Use static font
                    .foregroundColor(StaticAppColors.primaryText) // Use static color

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("$")
                        .font(StaticAppFonts.largeTitle)
                        .foregroundColor(StaticAppColors.primaryText)

                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(StaticAppFonts.largeTitle)
                        .foregroundColor(StaticAppColors.primaryText)
                        .multilineTextAlignment(.leading)
                        // .frame(width: 120) // Optional: Uncomment if needed
                }

                Button(action: {
                    print("Button tapped")
                    saveTransaction()
                }) {
                    // Apply the static style to the Text label
                    Text("Save")
                        .staticPrimaryButtonStyle(isEnabled: isFormValid) // Apply static style
                }
                // REMOVED: .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 50) // Keep padding for placement
                .disabled(!isFormValid) // Keep standard disable modifier

                Spacer()
            }
            .padding(.top, 20)

            // Top-left Close button
            Button(action: CloseSettings) {
                Text("Close")
                    .font(StaticAppFonts.body) // Use static font
                    .foregroundColor(StaticAppColors.primaryAccent) // Use static color directly
                    .padding()
            }
            // REMOVED: .tint(theme.colors.primaryAccent)
            .padding(.leading, 5)

        }
        .onTapGesture {
           hideKeyboard()
        }
    }
}


#if DEBUG
struct AddTransaction_Previews: PreviewProvider {
    static var previews: some View {
        AddTransaction(appManager: AppManager.instance, appData: AppDataManager.instance)
        // No theme injection needed
    }
}
#endif
