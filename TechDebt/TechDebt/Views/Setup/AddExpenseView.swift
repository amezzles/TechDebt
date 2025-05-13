import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var appData: AppDataManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.appTheme) var theme

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
                    .font(theme.fonts.body)
                    .foregroundColor(theme.colors.primaryText)

                TextField("Amount", text: $expenseAmountString)
                    .font(theme.fonts.body)
                    .foregroundColor(theme.colors.primaryText)
                    .keyboardType(.decimalPad)

                Picker(selection: $selectedRecurrence) {
                    ForEach(ExpenseRecurrence.allCases) { recurrence in
                        Text(recurrence.rawValue)
                            .font(theme.fonts.body)
                            .foregroundColor(theme.colors.primaryText)
                            .tag(recurrence)
                    }
                } label: {
                    Text("Frequency")
                        .font(theme.fonts.body)
                        .foregroundColor(theme.colors.primaryText)
                }

            }
             .toolbarColorScheme(.dark, for: .navigationBar)
             .toolbarBackground(theme.colors.primaryAccent, for: .navigationBar)
             .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Add Regular Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(theme.fonts.body)
                    .tint(theme.colors.accentText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExpense()
                        dismiss()
                    }
                    .font(theme.fonts.body.weight(.semibold))
                    .disabled(!isFormValid)
                    .tint(theme.colors.accentText)
                }
            }
        }
        .tint(theme.colors.primaryAccent)
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
