import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var appData: AppDataManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Button("Save Expense") {
                    // add regular expenditure
                    dismiss()
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
