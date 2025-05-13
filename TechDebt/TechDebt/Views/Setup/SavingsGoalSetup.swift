import SwiftUI

struct SavingsGoalSetup: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

    @State private var goalName: String = ""
    @State private var goalAmountString: String = ""

    var isFormValid: Bool {
        !goalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        ConvertValue.CurrencyToFloat(stringVal: goalAmountString) > 0
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                StaticSavingsGoalHeaderView()

                VStack(spacing: 20) {
                    TextField("What are you saving for? (e.g., Holiday, New Car)", text: $goalName)
                        .font(StaticAppFonts.body)
                        .foregroundColor(StaticAppColors.primaryText)
                        .padding(StaticStyleConstants.standardPadding / 2)
                        .background(StaticAppColors.secondaryBackground)
                        .cornerRadius(StaticStyleConstants.cornerRadius / 2)
                        .padding(.horizontal, 30)


                    TextField("How much do you want to save?", text: $goalAmountString)
                        .font(StaticAppFonts.body)
                        .foregroundColor(StaticAppColors.primaryText)
                        .keyboardType(.decimalPad)
                        .padding(StaticStyleConstants.standardPadding / 2)
                        .background(StaticAppColors.secondaryBackground)
                        .cornerRadius(StaticStyleConstants.cornerRadius / 2)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 30)

                Spacer()

                Button(action: {
                    saveSavingsGoal()
                    appManager.menuState = .mainMenu
                }) {
                    Text("Finish Setup")
                        .staticPrimaryButtonStyle(isEnabled: isFormValid)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 40)
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 0 : 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(StaticAppColors.primaryBackground.edgesIgnoringSafeArea(.all))
            .onAppear {
                loadExistingData()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func loadExistingData() {
        goalName = appData.data.saveGoalText
        if appData.data.saveGoalAmount > 0 {
            goalAmountString = ConvertValue.FloatToCurrency(floatVal: appData.data.saveGoalAmount)
        } else {
            goalAmountString = ""
        }
    }

    private func saveSavingsGoal() {
        _ = appData.SetSaveGoalText(stringVal: goalName)
        _ = appData.SetSaveGoalAmount(stringVal: goalAmountString)
        appData.data.hasSet = true
        appData.Save()
    }

     private func hideKeyboard() {
         UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
}

struct StaticSavingsGoalHeaderView: View {
    var body: some View {
        VStack {
            Text("Make a Budget")
                .font(StaticAppFonts.largeTitle)
                .foregroundColor(StaticAppColors.primaryAccent)
                .padding(.top, 40)
                .padding(.bottom, 50)

            Text("SAVINGS GOAL")
                .font(StaticAppFonts.title2.weight(.bold))
                .foregroundColor(StaticAppColors.primaryAccent)
                .padding(.bottom, 20)
        }
    }
}

#if DEBUG
struct SavingsGoalSetup_Previews: PreviewProvider {
    static var previews: some View {
        let appManager = AppManager.instance
        let appData = AppDataManager.instance
        appManager.menuState = .sSavingGoal
        return SavingsGoalSetup(appManager: appManager, appData: appData)
    }
}
#endif
