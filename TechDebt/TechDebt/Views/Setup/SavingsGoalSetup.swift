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
            ZStack {
                StaticAppColors.primaryBackground.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 0) {
                    StaticSavingsGoalHeaderViewOriginalTitles()
                        .padding(.bottom, StaticStyleConstants.standardPadding * 1.5)

                    VStack(alignment: .leading, spacing: StaticStyleConstants.standardPadding) {
                        Text("Goal Description")
                            .font(StaticAppFonts.headline)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .padding(.leading, 30)

                        TextField("What are you saving for? (e.g., Holiday, New Car)", text: $goalName)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.primaryText)
                            .padding(StaticStyleConstants.standardPadding * 0.75)
                            .background(StaticAppColors.secondaryBackground)
                            .cornerRadius(StaticStyleConstants.cornerRadius)
                            .padding(.horizontal, 30)

                        Text("Target Amount")
                            .font(StaticAppFonts.headline)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .padding(.leading, 30)
                            .padding(.top, StaticStyleConstants.standardPadding)

                        TextField("How much do you want to save? (\(Locale.current.currencySymbol ?? "$"))", text: $goalAmountString)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.primaryText)
                            .keyboardType(.decimalPad)
                            .padding(StaticStyleConstants.standardPadding * 0.75)
                            .background(StaticAppColors.secondaryBackground)
                            .cornerRadius(StaticStyleConstants.cornerRadius)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, StaticStyleConstants.standardPadding)

                    Spacer()

                    Button(action: {
                        saveSavingsGoal()
                        appData.data.hasSet = true
                        appData.Save()
                        appManager.BeginBudget()
                        appManager.menuState = .mainMenu
                    }) {
                        Text("Finish Setup")
                            .staticPrimaryButtonStyle(isEnabled: isFormValid)
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 40)
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? StaticStyleConstants.standardPadding : 30 + StaticStyleConstants.standardPadding)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
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
            goalAmountString = ConvertValue.FloatToCurrency(floatVal: appData.data.saveGoalAmount).replacingOccurrences(of: Locale.current.currencySymbol ?? "$", with: "")
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

struct StaticSavingsGoalHeaderViewOriginalTitles: View {
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
