import SwiftUI

struct BudgetSetupDetailsView: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

    @State private var budgetName: String = ""
    @State private var yearlyEarningsString: String = ""
    @State private var selectedCycle: BudgetCycle
    @State private var budgetStartDate: Date

    @State private var isNameValid: Bool = false
    @State private var areEarningsValid: Bool = false

    init(appManager: AppManager, appData: AppDataManager) {
        self.appManager = appManager
        self.appData = appData

        _budgetName = State(initialValue: appData.data.budgetName)
        let initialEarnings = appData.data.yearlyEarnings
        _yearlyEarningsString = State(initialValue: initialEarnings == 0 ? "" : ConvertValue.FloatToCurrency(floatVal: initialEarnings))
        _selectedCycle = State(initialValue: appData.data.budgetCycle)
        _budgetStartDate = State(initialValue: appData.data.budgetStartDate)

        _isNameValid = State(initialValue: !appData.data.budgetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        _areEarningsValid = State(initialValue: initialEarnings > 0)
    }

    private var isFormValid: Bool {
        isNameValid && areEarningsValid
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Make a Budget")
                        .font(StaticAppFonts.largeTitle)
                        .foregroundColor(StaticAppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(StaticAppColors.primaryBackground)


                    HStack {
                        Text("Name:")
                            .font(StaticAppFonts.headline)
                            .foregroundColor(StaticAppColors.primaryText)
                        TextField("e.g., My Monthly Budget", text: $budgetName)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .onChange(of: budgetName) { newValue in
                                isNameValid = !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                appData.setBudgetName(newValue)
                            }
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
                             .font(StaticAppFonts.headline)
                             .foregroundColor(StaticAppColors.primaryText)
                     }
                     .tint(StaticAppColors.primaryAccent)
                     .listRowBackground(StaticAppColors.secondaryBackground)
                     .onChange(of: selectedCycle) { newValue in
                        appData.setBudgetCycle(newValue)
                    }

                    DatePicker(selection: $budgetStartDate, displayedComponents: .date) {
                         Text("Budget Start Date:")
                             .font(StaticAppFonts.headline)
                             .foregroundColor(StaticAppColors.primaryText)
                     }
                     .tint(StaticAppColors.primaryAccent)
                     .listRowBackground(StaticAppColors.secondaryBackground)
                     .onChange(of: budgetStartDate) { newValue in
                            appData.setBudgetStartDate(newValue)
                        }

                    HStack {
                        Text("Yearly Earnings:")
                            .font(StaticAppFonts.headline)
                            .foregroundColor(StaticAppColors.primaryText)
                        TextField(ConvertValue.FloatToCurrency(floatVal: 0.0), text: $yearlyEarningsString)
                            .font(StaticAppFonts.body)
                            .foregroundColor(StaticAppColors.secondaryText)
                            .keyboardType(.decimalPad)
                            .onChange(of: yearlyEarningsString) { newValue in
                                let floatValue = ConvertValue.CurrencyToFloat(stringVal: newValue)
                                areEarningsValid = floatValue > 0
                                appData.setYearlyEarnings(stringVal: newValue)
                            }
                    }
                    .listRowBackground(StaticAppColors.secondaryBackground)
                }
                .listRowSeparatorTint(StaticAppColors.primaryBackground)


                Section {
                    Button(action: {
                        appData.setBudgetName(budgetName)
                        appData.setYearlyEarnings(stringVal: yearlyEarningsString)
                        appData.setBudgetCycle(selectedCycle)
                        appData.setBudgetStartDate(budgetStartDate)
                        appData.finalizeBudgetDetails()
                        appManager.menuState = .sRegularExpenditure
                        appData.data.budgetRemaining = appData.data.budgetAmount
                    }) {
                        Text("Continue")
                            .staticPrimaryButtonStyle(isEnabled: isFormValid)
                    }
                    .disabled(!isFormValid)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(StaticAppColors.primaryBackground)
                }
                .listRowSeparatorTint(StaticAppColors.primaryBackground)
            }
            .background(StaticAppColors.primaryBackground)
            .scrollContentBackground(.hidden)
            .navigationTitle("Budget Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(StaticAppColors.primaryAccent, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .accentColor(StaticAppColors.primaryAccent)
        .onAppear {
            self.budgetName = appData.data.budgetName
            let earnings = appData.data.yearlyEarnings
            self.yearlyEarningsString = earnings == 0 ? "" : ConvertValue.FloatToCurrency(floatVal: earnings)
            self.selectedCycle = appData.data.budgetCycle
            self.budgetStartDate = appData.data.budgetStartDate

            isNameValid = !self.budgetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            areEarningsValid = earnings > 0
        }
    }
}

#if DEBUG
struct BudgetSetupDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetSetupDetailsView(appManager: AppManager.instance, appData: AppDataManager.instance)
    }
}
#endif
