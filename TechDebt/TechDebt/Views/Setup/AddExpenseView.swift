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

                TextField("Amount", text: $expenseAmountString)
                    .keyboardType(.decimalPad)

                Picker("Frequency", selection: $selectedRecurrence) {
                    ForEach(ExpenseRecurrence.allCases) { recurrence in
                        Text(recurrence.rawValue).tag(recurrence)
                    }
                }
            }
            .navigationTitle("Add Regular Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExpense()
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }

    private func saveExpense() {
        guard let amount = Float(expenseAmountString.filter("0123456789.".contains)), amount > 0 else {
             print("Invalid amount entered")
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
