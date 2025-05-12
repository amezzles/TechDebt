import SwiftUI

struct RegularExpendituresSetup: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager
    @State private var isPresentingAddExpenseSheet = false

    var totalExpensesPerBudgetPeriod: Float {
        appData.data.regularExpenditures.reduce(0) { $0 + $1.expenditureAmountPerBudgetPeriod }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SetupHeaderView()

            AddExpenseButtonView(isPresentingAddExpenseSheet: $isPresentingAddExpenseSheet)

            ExpenseListBoxView(appData: appData)

            HStack {
                Text("Total per \(appData.data.budgetCycle.rawValue) budget:")
                    .font(.headline)
                Spacer()
                Text(ConvertValue.FloatToCurrency(floatVal: totalExpensesPerBudgetPeriod))
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding()
            Spacer()
            Button(action: {
                appManager.menuState = .sSavingGoal
            }) {
                Text("Continue")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isPresentingAddExpenseSheet) {
            AddExpenseView(appData: appData)
        }
        .onAppear {
            appData.data.regularExpenditures.indices.forEach { index in
                 appData.data.regularExpenditures[index].SetExpenditureForBudget(period: appData.data.budgetPeriod)
            }
        }
    }
}

struct SetupHeaderView: View {
    var body: some View {
        VStack {
            Text("Make a Budget")
                .font(.custom("Kath-Regular copy", size: 34))
                .fontWeight(.heavy)
                .foregroundColor(Color("#0040A8"))
                .padding(.top, 40)

            Text("REGULAR EXPENSES")
                .font(.custom("Kaph-Regular copy", size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color("#0040A8"))
                .padding(.bottom, 25)
        }
    }
}

struct AddExpenseButtonView: View {
    @Binding var isPresentingAddExpenseSheet: Bool

    var body: some View {
        Button(action: { isPresentingAddExpenseSheet = true }) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(UIColor.darkGray).opacity(0.9))
                Text("ADD EXPENSE")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .padding(.bottom, 25)
    }
}

struct ExpenseListBoxView: View {
    @ObservedObject var appData: AppDataManager

    var body: some View {
        Group {
            if appData.data.regularExpenditures.isEmpty {
                VStack(spacing: 0) {
                    ExpensePlaceholderRowView(text: "Mortgage payment, rent, electricity, water, internet, gym")
                    CustomListDivider()
                    ExpensePlaceholderRowView()
                    CustomListDivider()
                    ExpensePlaceholderRowView()
                }
            } else {
                List {
                    ForEach(appData.data.regularExpenditures) { expense in
                        ExpenseRowView(expense: expense)
                            .listRowInsets(EdgeInsets())
                            .background(Color(UIColor.systemGray6))
                    }
                    // removeRegularExpenditure should be a method in AppDataManager
                    .onDelete(perform: appData.removeRegularExpenditure)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
        .frame(minHeight: 160, maxHeight: 220)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal, 30)
    }
}

struct ExpensePlaceholderRowView: View {
    var text: String? = nil

    var body: some View {
        HStack {
            if let text = text {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 12)
            } else {
                Spacer().frame(height: 1)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color(UIColor.systemGray6))
    }
}

struct ExpenseRowView: View {
    let expense: ExpenditureItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.expenditureName)
                    .font(.system(size: 15, weight: .medium))
                Text("Every \(ExpenseRecurrence.allCases.first(where: {$0.days == expense.expenditurePeriod})?.rawValue ?? "\(expense.expenditurePeriod) days")")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(ConvertValue.FloatToCurrency(floatVal: expense.expenditureAmount))
                .font(.system(size: 15, weight: .medium))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

struct CustomListDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.gray.opacity(0.3))
    }
}

extension Color {
    init(_ hex: String) {
        let trimmedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: trimmedHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch trimmedHex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0) // Default to black
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// Preview
#if DEBUG
struct RegularExpendituresSetup_Previews: PreviewProvider {
    static var previews: some View {

        let appManager = AppManager.instance
        let appData = AppDataManager.instance

         appData.data.regularExpenditures = [
            ExpenditureItem(id: UUID(), expenditureName: "Mortgage/Rent", expenditureAmount: 1250.00, expenditurePeriod: 30),
            ExpenditureItem(id: UUID(), expenditureName: "Internet Bill", expenditureAmount: 65.00, expenditurePeriod: 30),
            ExpenditureItem(id: UUID(), expenditureName: "Gym Membership", expenditureAmount: 40.00, expenditurePeriod: 30)
         ]
        appData.data.regularExpenditures.indices.forEach { index in
             appData.data.regularExpenditures[index].SetExpenditureForBudget(period: appData.data.budgetPeriod)
        }
        return RegularExpendituresSetup(appManager: appManager, appData: appData)
    }
}
#endif
