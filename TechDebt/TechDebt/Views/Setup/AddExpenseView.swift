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
            Form {
                TextField("Expense Name (e.g., Rent, Netflix)", text: $expenseName)
                    .font(StaticAppFonts.body)

                TextField("Amount", text: $expenseAmountString)
                    .font(StaticAppFonts.body)
                    .keyboardType(.decimalPad)

                Picker(selection: $selectedRecurrence) {
                    ForEach(ExpenseRecurrence.allCases) { recurrence in
                        Text(recurrence.rawValue)
                            .font(StaticAppFonts.body)
                            .tag(recurrence)
                    }
                } label: {
                    Text("Frequency")
                        .font(StaticAppFonts.body)
                }
                 .tint(StaticAppColors.primaryAccent)

            }
            .toolbarBackground(StaticAppColors.primaryAccent, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)

            .navigationTitle("Add Regular Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(StaticAppFonts.body)
                    .tint(StaticAppColors.accentText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExpense()
                        dismiss()
                    }
                    .font(StaticAppFonts.body.weight(.semibold))
                    .disabled(!isFormValid)
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
