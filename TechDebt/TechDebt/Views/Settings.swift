import SwiftUI

struct AppSettings: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager
    
    @State private var budgetAmountText = ""
    @State private var budgetPeriodText = ""
    @State private var saveGoalAmountText = ""
    @State private var saveGoalText = ""
    
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    Button(action: CloseSettings) {
                        Text("Close")
                            .font(.system(size: 24))
                            .padding(.top, 10.0)
                            .padding(.leading, 30.0)
                    }
                    Spacer()
                }
                Text("Settings")
                    .font(.system(size: 48))
                    .fontWeight(Font.Weight.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5.0)
                
                Form {
                    VStack {
                        HStack {
                            Text("Budget Amount")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 30.0)
                            Spacer()
                        }
                        .padding(.top, 6.0)
                        TextField("What's your budget?", text: $budgetAmountText)
                            .font(.system(size: 24))
                            .padding(.leading, 30.0)
                            .keyboardType(.decimalPad)
                            .onSubmit {
                                budgetAmountText = appData.SetBudgetAmount(stringVal: budgetAmountText)
                            }
                    }
                    
                    VStack {
                        HStack {
                            Text("Budget Period")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 30.0)
                            Spacer()
                        }
                        .padding(.top, 6.0)
                        TextField("How often?", text: $budgetPeriodText)
                            .font(.system(size: 24))
                            .padding(.leading, 30.0)
                            .keyboardType(.decimalPad)
                            .onSubmit {
                                budgetPeriodText = appData.SetBudgetPeriod(stringVal: budgetPeriodText)
                            }
                    }
                    
                    VStack {
                        HStack {
                            Text("Savings Goal")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 30.0)
                            Spacer()
                        }
                        .padding(.top, 6.0)
                        TextField("What are you saving for?", text: $saveGoalText)
                            .font(.system(size: 24))
                            .padding(.leading, 30.0)
                            .keyboardType(.decimalPad)
                            .onSubmit {
                                saveGoalText = appData.SetSaveGoalText(stringVal: saveGoalText)
                            }
                        HStack {
                            Text("Amount Needed")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 30.0)
                            Spacer()
                        }
                        TextField("How much do you need?", text: $saveGoalAmountText)
                            .font(.system(size: 24))
                            .padding(.leading, 30.0)
                            .keyboardType(.decimalPad)
                            .onSubmit {
                                saveGoalAmountText = appData.SetSaveGoalAmount(stringVal: saveGoalAmountText)
                            }
                    }
                }
                
                Button(action: ResetApp) {
                    Text("Reset App")
                        .foregroundStyle(.red)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.top, 10.0)
                }
                Spacer()
                
            }
        }
        .onAppear() {
            budgetAmountText = ConvertValue.FloatToCurrency(floatVal: appData.data.budgetAmount)
            budgetPeriodText = ConvertValue.IntToDays(intVal: appData.data.budgetPeriod)
            saveGoalText = appData.data.saveGoalText
            saveGoalAmountText = ConvertValue.FloatToCurrency(floatVal: appData.data.saveAmount)
        }
        .onDisappear() {
            _ = appData.SetBudgetAmount(stringVal: budgetAmountText)
            _ = appData.SetBudgetPeriod(stringVal: budgetPeriodText)
            _ = appData.SetSaveGoalText(stringVal: saveGoalText)
            _ = appData.SetSaveGoalAmount(stringVal: saveGoalAmountText)
        }
    }
    
    func CloseSettings(){
        appManager.menuState = .mainMenu
    }
    
    func ResetApp(){
        budgetAmountText = ""
        budgetPeriodText = ""
        saveGoalText = ""
        saveGoalAmountText = ""
        appManager.Reset()
    }
}
