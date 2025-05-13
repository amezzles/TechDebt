import SwiftUI

struct AddTransaction: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

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
        ZStack(alignment: .topTrailing) {
            StaticAppColors.primaryBackground.ignoresSafeArea()

            VStack(alignment: .center, spacing: StaticStyleConstants.standardPadding * 2) {
                
                Text("New Transaction")
                    .font(StaticAppFonts.largeTitle.weight(.bold))
                    .foregroundColor(StaticAppColors.primaryText)
                    .padding(.top, StaticStyleConstants.standardPadding * 2)
                
                Spacer()

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("$")
                        .font(StaticAppFonts.largeTitle.weight(.bold))
                        .foregroundColor(StaticAppColors.primaryText)

                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(StaticAppFonts.largeTitle.weight(.bold))
                        .foregroundColor(StaticAppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 100, idealWidth: 150, maxWidth: 200)
                        .padding(StaticStyleConstants.standardPadding / 2)
                        .background(StaticAppColors.secondaryBackground)
                        .cornerRadius(StaticStyleConstants.cornerRadius / 2)
                }
                .padding(.horizontal, StaticStyleConstants.standardPadding)


                Spacer()
                Spacer()


                Button(action: {
                    saveTransaction()
                }) {
                    Text("Save Transaction")
                        .staticPrimaryButtonStyle(isEnabled: isFormValid)
                }
                .padding(.horizontal, StaticStyleConstants.standardPadding * 2.5)
                .disabled(!isFormValid)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)


            Button(action: CloseSettings) {
                Image(systemName: "xmark.circle.fill")
                    .font(StaticAppFonts.title2.weight(.semibold))
                    .foregroundColor(StaticAppColors.secondaryText)
                    .padding()
            }
            .padding(.trailing, StaticStyleConstants.standardPadding / 2 )
            .padding(.top, StaticStyleConstants.standardPadding / 2)
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
    }
}
#endif
