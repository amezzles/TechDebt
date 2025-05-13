import SwiftUI

struct AppSettings: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager
    
    @State private var budgetName: String = ""
    @State private var yearlyEarningsString: String = ""
    @State private var selectedCycle: BudgetCycle
    @State private var budgetStartDate: Date
    @State private var saveGoalAmountText: String = ""
    @State private var saveGoalText: String = ""
    
    init(appManager: AppManager, appData: AppDataManager) {
        self.appManager = appManager
        self.appData = appData
        
        _budgetName = State(initialValue: appData.data.budgetName)
        let initialEarnings = appData.data.yearlyEarnings
        _yearlyEarningsString = State(initialValue: initialEarnings == 0 ? "" : ConvertValue.FloatToCurrency(floatVal: initialEarnings))
        _selectedCycle = State(initialValue: appData.data.budgetCycle)
        _budgetStartDate = State(initialValue: appData.data.budgetStartDate)
        _saveGoalAmountText = State(initialValue: ConvertValue.FloatToCurrency(floatVal: appData.data.saveGoalAmount))
        _saveGoalText = State(initialValue: appData.data.saveGoalText)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Budget Details").font(StaticAppFonts.headline).foregroundColor(StaticAppColors.primaryText)) {
                    HStack {
                        Text("Name:")
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.primaryText)
                        TextField("e.g., My Monthly Budget", text: $budgetName)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .onSubmit { appData.setBudgetName(budgetName) }
                    }
                    .listRowBackground(StaticAppColors.secondaryBackground)

                    Picker(selection: $selectedCycle) {
                        ForEach(BudgetCycle.allCases) { cycle in
                            Text(cycle.rawValue)
                                .font(StaticAppFonts.body)
                                .tag(cycle)
                        }
                    } label: {
                         Text("Budget Period:")
                             .font(StaticAppFonts.body)
                             .foregroundColor(StaticAppColors.primaryText)
                     }
                     .tint(StaticAppColors.primaryAccent)
                     .listRowBackground(StaticAppColors.secondaryBackground)
                     .onChange(of: selectedCycle) { newValue in
                        appData.setBudgetCycle(newValue)
                    }

                    DatePicker(selection: $budgetStartDate, displayedComponents: .date) {
                         Text("Budget Start Date:")
                             .font(StaticAppFonts.body)
                             .foregroundColor(StaticAppColors.primaryText)
                     }
                     .tint(StaticAppColors.primaryAccent)
                     .listRowBackground(StaticAppColors.secondaryBackground)
                     .onChange(of: budgetStartDate) { newValue in
                            appData.setBudgetStartDate(newValue)
                        }
                    
                    HStack {
                        Text("Yearly Earnings:")
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.primaryText)
                        TextField(ConvertValue.FloatToCurrency(floatVal: 0.0), text: $yearlyEarningsString)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .keyboardType(.decimalPad)
                            .onSubmit { appData.setYearlyEarnings(stringVal: yearlyEarningsString) }
                    }
                    .listRowBackground(StaticAppColors.secondaryBackground)
                }
                .listRowSeparatorTint(StaticAppColors.primaryBackground)

                Section(header: Text("Savings Goal").font(StaticAppFonts.headline).foregroundColor(StaticAppColors.primaryText)) {
                    HStack {
                        Text("Goal Name:")
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.primaryText)
                        TextField("What are you saving for?", text: $saveGoalText)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .onSubmit { saveGoalText = appData.SetSaveGoalText(stringVal: saveGoalText) }
                    }
                    .listRowBackground(StaticAppColors.secondaryBackground)
                    
                    HStack {
                        Text("Amount Needed:")
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.primaryText)
                        TextField("How much do you need?", text: $saveGoalAmountText)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .keyboardType(.decimalPad)
                            .onSubmit { saveGoalAmountText = appData.SetSaveGoalAmount(stringVal: saveGoalAmountText) }
                    }
                    .listRowBackground(StaticAppColors.secondaryBackground)
                }
                .listRowSeparatorTint(StaticAppColors.primaryBackground)

                Section {
                    Button(action: ResetApp) {
                        HStack {
                            Spacer()
                            Text("Reset App Data")
                                .font(StaticAppFonts.body.weight(.semibold))
                                .foregroundColor(StaticAppColors.error)
                            Spacer()
                        }
                    }
                    .listRowBackground(StaticAppColors.secondaryBackground)
                }
                .listRowSeparatorTint(StaticAppColors.primaryBackground)
            }
            .background(StaticAppColors.primaryBackground)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(StaticAppColors.primaryAccent, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        CloseSettings()
                    }
                    .font(StaticAppFonts.body)
                    .tint(StaticAppColors.accentText)
                }
            }
        }
        .accentColor(StaticAppColors.primaryAccent)
        .onDisappear() {
            appData.setBudgetName(budgetName)
            appData.setYearlyEarnings(stringVal: yearlyEarningsString)
            appData.setBudgetCycle(selectedCycle)
            appData.setBudgetStartDate(budgetStartDate)
            saveGoalText = appData.SetSaveGoalText(stringVal: saveGoalText)
            saveGoalAmountText = appData.SetSaveGoalAmount(stringVal: saveGoalAmountText)
            appData.finalizeBudgetDetails()
            appData.Save()
        }
        .onAppear {
            self.budgetName = appData.data.budgetName
            let earnings = appData.data.yearlyEarnings
            self.yearlyEarningsString = earnings == 0 ? "" : ConvertValue.FloatToCurrency(floatVal: earnings)
            self.selectedCycle = appData.data.budgetCycle
            self.budgetStartDate = appData.data.budgetStartDate
            self.saveGoalText = appData.data.saveGoalText
            self.saveGoalAmountText = appData.data.saveGoalAmount == 0 ? "" : ConvertValue.FloatToCurrency(floatVal: appData.data.saveGoalAmount)
        }
    }
    
    func CloseSettings(){
        hideKeyboard()
        appManager.menuState = .mainMenu
    }
    
    func ResetApp(){
        budgetName = ""
        yearlyEarningsString = ""
        selectedCycle = .monthly
        budgetStartDate = Date()
        saveGoalText = ""
        saveGoalAmountText = ""
        appManager.Reset()
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#if DEBUG
struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettings(appManager: AppManager.instance, appData: AppDataManager.instance)
    }
}
#endif
