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
            ZStack {
                StaticAppColors.primaryBackground.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    Text("Make a Budget")
                        .font(StaticAppFonts.largeTitle)
                        .foregroundColor(StaticAppColors.primaryAccent)
                        .padding(.top, StaticStyleConstants.standardPadding * 1.5)
                        .padding(.bottom, 50)

                    Text("BUDGET DETAILS")
                        .font(StaticAppFonts.title2.weight(.bold))
                        .foregroundColor(StaticAppColors.primaryAccent)
                        .padding(.bottom, StaticStyleConstants.standardPadding)


                    Form {
                        Section(header: Text("Information").font(StaticAppFonts.headline).foregroundColor(StaticAppColors.secondaryText)) {
                            HStack {
                                Text("Name:")
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.primaryText)
                                Spacer()
                                TextField("e.g., My Monthly Budget", text: $budgetName)
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.secondaryText)
                                    .multilineTextAlignment(.trailing)
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
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .navigationBarHidden(true)
        }
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
