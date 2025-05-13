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
    @State private var newExpenditureName: String = ""
    @State private var newExpenditureAmount: String = ""
    @State private var newExpenditureRecurrence: ExpenseRecurrence = .monthly
    
    init(appManager: AppManager, appData: AppDataManager) {
        self.appManager = appManager
        self.appData = appData
        
        _budgetName = State(initialValue: appData.data.budgetName)
        let initialEarnings = appData.data.yearlyEarnings
        _yearlyEarningsString = State(initialValue: initialEarnings == 0 ? "" : ConvertValue.FloatToCurrency(floatVal: initialEarnings))
        _selectedCycle = State(initialValue: appData.data.budgetCycle)
        _budgetStartDate = State(initialValue: appData.data.budgetStartDate)
        _saveGoalAmountText = State(initialValue: appData.data.saveGoalAmount == 0 ? "" : ConvertValue.FloatToCurrency(floatVal: appData.data.saveGoalAmount))
        _saveGoalText = State(initialValue: appData.data.saveGoalText)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticAppColors.primaryBackground.edgesIgnoringSafeArea(.all)
                VStack(spacing:0) {
                    HStack {
                        Spacer()
                        Text("Settings")
                            .font(StaticAppFonts.largeTitle.weight(.bold))
                            .foregroundColor(StaticAppColors.primaryText)
                        Spacer()
                        Button(action: CloseSettings) {
                            Image(systemName: "xmark.circle.fill")
                                .font(StaticAppFonts.title2)
                                .foregroundColor(StaticAppColors.secondaryText)
                        }
                        .padding(.trailing, StaticStyleConstants.standardPadding)
                    }
                    .padding(.top, StaticStyleConstants.standardPadding)
                    .padding(.bottom, StaticStyleConstants.standardPadding)
                    
                    Form {
                        Section(header: Text("Budget Details").font(StaticAppFonts.headline).foregroundColor(StaticAppColors.secondaryText)) {
                            HStack {
                                Text("Name:")
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.primaryText)
                                Spacer()
                                TextField("e.g., My Monthly Budget", text: $budgetName)
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.secondaryText)
                                    .multilineTextAlignment(.trailing)
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
                                Spacer()
                                TextField(ConvertValue.FloatToCurrency(floatVal: 0.0), text: $yearlyEarningsString)
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.secondaryText)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .onSubmit { appData.setYearlyEarnings(stringVal: yearlyEarningsString) }
                            }
                            .listRowBackground(StaticAppColors.secondaryBackground)
                        }
                        .listRowSeparatorTint(StaticAppColors.primaryBackground)

                        Section(header: Text("Savings Goal").font(StaticAppFonts.headline).foregroundColor(StaticAppColors.secondaryText)) {
                            HStack {
                                Text("Goal Name:")
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.primaryText)
                                Spacer()
                                TextField("What are you saving for?", text: $saveGoalText)
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.secondaryText)
                                    .multilineTextAlignment(.trailing)
                                    .onSubmit { saveGoalText = appData.SetSaveGoalText(stringVal: saveGoalText) }
                            }
                            .listRowBackground(StaticAppColors.secondaryBackground)
                            
                            HStack {
                                Text("Amount Needed:")
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.primaryText)
                                Spacer()
                                TextField("How much do you need?", text: $saveGoalAmountText)
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.secondaryText)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .onSubmit { saveGoalAmountText = appData.SetSaveGoalAmount(stringVal: saveGoalAmountText) }
                            }
                            .listRowBackground(StaticAppColors.secondaryBackground)
                        }
                        .listRowSeparatorTint(StaticAppColors.primaryBackground)

                        ExpendituresSection
                        
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
                            .listRowBackground(Color.white)
                        }
                        .listRowSeparatorTint(StaticAppColors.primaryBackground)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .navigationBarHidden(true)
        }
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
    
    private var ExpendituresSection: some View {
        return Section(header: Text("Regular Expenditures")
            .font(StaticAppFonts.headline)
            .foregroundColor(StaticAppColors.primaryText)) {

            ForEach(appData.data.regularExpenditures) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.expenditureName)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.primaryText)
                        Text("(\(ConvertValue.IntToDays(intVal: item.expenditurePeriod)))")
                            .font(StaticAppFonts.caption)
                            .foregroundColor(StaticAppColors.secondaryText)
                        }
                        Spacer()
                    Text(ConvertValue.FloatToCurrency(floatVal: item.expenditureAmount))
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.secondaryText)
                    }
                }
                .onDelete { offsets in
                    appData.removeRegularExpenditure(at: offsets)
            }
            .listRowBackground(StaticAppColors.secondaryBackground)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    TextField("Expense name", text: $newExpenditureName)
                        .font(StaticAppFonts.body)
                        .foregroundColor(StaticAppColors.secondaryText)
                    
                    TextField("Amount", text: $newExpenditureAmount)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                        .font(StaticAppFonts.body)
                        .foregroundColor(StaticAppColors.secondaryText)
                }
                
                Picker("Recurrence", selection: $newExpenditureRecurrence) {
                    ForEach(ExpenseRecurrence.allCases) { recurrence in
                        Text(recurrence.rawValue).tag(recurrence)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .font(StaticAppFonts.body)
                .tint(StaticAppColors.primaryAccent)
                
                HStack {
                    Spacer()
                    Button("Add Expenditure") {
                        var newExpenditure = ExpenditureItem( expenditureName: newExpenditureName, expenditureAmount: Float(ConvertValue.DaysToInt(stringVal: newExpenditureAmount)), expenditurePeriod: newExpenditureRecurrence.days)
                        newExpenditure.SetExpenditureForBudget(period: appData.data.budgetPeriod)
                        appData.addRegularExpenditure(newExpenditure)
                        newExpenditureName = ""
                        newExpenditureAmount = ""
                        newExpenditureRecurrence = .monthly
                    }
                    .listRowBackground(StaticAppColors.secondaryBackground)
                    .font(StaticAppFonts.body.weight(.semibold))
                    .foregroundColor(StaticAppColors.primaryAccent)
                    .disabled(newExpenditureName.isEmpty || Float(newExpenditureAmount) == nil)
                    .listRowSeparatorTint(StaticAppColors.primaryBackground)
                    .background(StaticAppColors.secondaryBackground)
                    Spacer()
                }
            }
            .padding(.top, 8)
            .listRowBackground(StaticAppColors.secondaryBackground)
        }
    }
}

#if DEBUG
struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettings(appManager: AppManager.instance, appData: AppDataManager.instance)
    }
}
#endif
