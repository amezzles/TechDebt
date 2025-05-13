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
                SavingsGoalHeaderView()

                VStack(spacing: 20) {
                    TextField("What are you saving for? (e.g., Holiday, New Car)", text: $goalName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 30)

                    TextField("How much do you want to save?", text: $goalAmountString)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 30)
                }
                .padding(.top, 30)

                Spacer()

                Button(action: {
                    saveSavingsGoal()
                    print("Savings Goal Saved. Navigate next.")
                    appManager.menuState = .mainMenu
                }) {
                    Text("Finish Setup")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? Color.accentColor : Color.gray)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 40)
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 0 : 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.all))
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
            goalAmountString = String(format: "%.2f", appData.data.saveGoalAmount)
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

struct SavingsGoalHeaderView: View {
    var body: some View {
        VStack {
            Text("Make a Budget")
                .font(.custom("Kath-Regular copy", size: 34))
                .fontWeight(.heavy)
                .foregroundColor(Color("#0040A8"))
                .padding(.top, 40)
                .padding(.bottom, 50)
            
            Text("SAVINGS GOAL")
                .font(.custom("Kaph-Regular copy", size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("#0040A8"))
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
#endif // DEBUG
