import SwiftUI

struct BudgetSetupDetailsView: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

    @State private var budgetName: String = ""
    @State private var yearlyEarningsString: String = ""
    @State private var selectedCycle: BudgetCycle
    @State private var budgetStartDate: Date

    // For validation
    @State private var isNameValid: Bool = false
    @State private var areEarningsValid: Bool = false

    init(appManager: AppManager, appData: AppDataManager) {
        self.appManager = appManager
        self.appData = appData

        _budgetName = State(initialValue: appData.data.budgetName)
        _yearlyEarningsString = State(initialValue: appData.getYearlyEarningsString() == "$0" ? "" : appData.getYearlyEarningsString())
        _selectedCycle = State(initialValue: appData.data.budgetCycle)
        _budgetStartDate = State(initialValue: appData.data.budgetStartDate)

        _isNameValid = State(initialValue: !appData.data.budgetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        _areEarningsValid = State(initialValue: appData.data.yearlyEarnings > 0)
    }
    
    private var isFormValid: Bool {
        isNameValid && areEarningsValid
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Make a Budget")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                        .listRowInsets(EdgeInsets())
                        .background(Color(UIColor.systemGroupedBackground))

                    HStack {
                        Text("Name:")
                            .font(.headline)
                        TextField("e.g., My Monthly Budget", text: $budgetName)
                            .onChange(of: budgetName) { newValue in
                                isNameValid = !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                appData.setBudgetName(newValue) // Update AppData immediately or on continue
                            }
                    }

                    Picker("Budget Period:", selection: $selectedCycle) {
                        ForEach(BudgetCycle.allCases) { cycle in
                            Text(cycle.rawValue).tag(cycle)
                        }
                    }
                    .font(.headline)
                    .onChange(of: selectedCycle) { newValue in
                        appData.setBudgetCycle(newValue)
                    }

                    DatePicker("Budget Start Date:", selection: $budgetStartDate, displayedComponents: .date)
                        .font(.headline)
                        .onChange(of: budgetStartDate) { newValue in
                            appData.setBudgetStartDate(newValue)
                        }
                    
                    HStack {
                        Text("Yearly Earnings:")
                            .font(.headline)
                        TextField("$0.00", text: $yearlyEarningsString)
                            .keyboardType(.decimalPad)
                            .onChange(of: yearlyEarningsString) { newValue in
                                let floatValue = ConvertValue.CurrencyToFloat(stringVal: newValue)
                                areEarningsValid = floatValue > 0
                                appData.setYearlyEarnings(stringVal: newValue)
                            }
                    }
                }

                Section {
                    Button(action: {
                        appData.setBudgetName(budgetName)
                        appData.setYearlyEarnings(stringVal: yearlyEarningsString)
                        appData.setBudgetCycle(selectedCycle)
                        appData.setBudgetStartDate(budgetStartDate)
                        
                        appData.finalizeBudgetDetails()

                        appManager.menuState = .sRegularExpenditure
                    }) {
                        Text("Continue")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isFormValid ? Color.accentColor : Color.gray)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .disabled(!isFormValid)
                    .listRowInsets(EdgeInsets())
                }
            }
            .navigationTitle("Budget Setup")
            .navigationBarTitleDisplayMode(.inline)
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
