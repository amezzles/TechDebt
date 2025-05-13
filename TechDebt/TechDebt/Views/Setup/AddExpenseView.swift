import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var appData: AppDataManager
    @Environment(\.dismiss) var dismiss

    @State private var expenseName: String = ""
    @State private var expenseAmountString: String = ""
    @State private var selectedRecurrence: ExpenseRecurrence = .monthly

    var isFormValid: Bool {
        !expenseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        ConvertValue.CurrencyToFloat(stringVal: expenseAmountString) > 0
    }

    var body: some View {
        NavigationView {
            ZStack {
                StaticAppColors.primaryBackground.edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    Text("Add Regular Expense")
                        .font(StaticAppFonts.title1.weight(.bold))
                        .foregroundColor(StaticAppColors.primaryText)
                        .padding(.top, StaticStyleConstants.standardPadding * 2)
                        .padding(.bottom, StaticStyleConstants.standardPadding)


                    Form {
                        Section(header: Text("Details").font(StaticAppFonts.headline).foregroundColor(StaticAppColors.secondaryText)) {
                            TextField("Expense Name (e.g., Rent, Netflix)", text: $expenseName)
                                .font(StaticAppFonts.body)
                                .foregroundColor(StaticAppColors.primaryText)
                        }
                        .listRowBackground(StaticAppColors.secondaryBackground)

                        Section(header: Text("Amount & Frequency").font(StaticAppFonts.headline).foregroundColor(StaticAppColors.secondaryText)) {
                            TextField("Amount", text: $expenseAmountString)
                                .font(StaticAppFonts.body)
                                .foregroundColor(StaticAppColors.primaryText)
                                .keyboardType(.decimalPad)
                                .listRowBackground(StaticAppColors.secondaryBackground)

                            Picker(selection: $selectedRecurrence) {
                                ForEach(ExpenseRecurrence.allCases) { recurrence in
                                    Text(recurrence.rawValue)
                                        .font(StaticAppFonts.body)
                                        .tag(recurrence)
                                }
                            } label: {
                                Text("Frequency")
                                    .font(StaticAppFonts.body)
                                    .foregroundColor(StaticAppColors.primaryText)
                            }
                            .tint(StaticAppColors.primaryAccent)
                            .listRowBackground(StaticAppColors.secondaryBackground)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)

                    Spacer()

                    Button(action: {
                        saveExpense()
                        dismiss()
                    }) {
                        Text("Add Expense")
                            .staticPrimaryButtonStyle(isEnabled: isFormValid)
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, StaticStyleConstants.standardPadding * 2)
                    .padding(.bottom, StaticStyleConstants.standardPadding * 2)
                }
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(StaticAppFonts.body)
                    .tint(StaticAppColors.accentText)
                }
            }
        }
    }

    private func saveExpense() {
        let amount = ConvertValue.CurrencyToFloat(stringVal: expenseAmountString)
        guard amount > 0 else {
             print("Invalid amount entered: \(expenseAmountString)")
             return
         }

        let newExpense = ExpenditureItem(
            expenditureName: expenseName,
            expenditureAmount: amount,
            expenditurePeriod: selectedRecurrence.days
        )
        appData.addRegularExpenditure(newExpense)
    }
}

#if DEBUG
struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(appData: AppDataManager.instance)
    }
}
#endif
