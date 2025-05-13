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

            StaticSetupHeaderView()
            StaticExpenseListBoxView(appData: appData)

            HStack {
                Text("Total per \(appData.data.budgetCycle.rawValue) budget:")
                    .font(StaticAppFonts.headline)
                    .foregroundColor(StaticAppColors.primaryText)
                Spacer()
                Text(ConvertValue.FloatToCurrency(floatVal: totalExpensesPerBudgetPeriod))
                    .font(StaticAppFonts.headline.weight(.bold))
                    .foregroundColor(StaticAppColors.primaryText)
            }
            .padding(.horizontal, StaticStyleConstants.standardPadding * 2)
            .padding(.vertical, StaticStyleConstants.standardPadding)


            StaticAddExpenseButtonView(isPresentingAddExpenseSheet: $isPresentingAddExpenseSheet)
            Spacer()
            Button(action: {
                appManager.menuState = .sSavingGoal
            }) {
                Text("Continue")
                    .staticPrimaryButtonStyle()
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(StaticAppColors.primaryBackground.edgesIgnoringSafeArea(.all))
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

struct StaticSetupHeaderView: View {
    var body: some View {
        VStack {
            Text("Make a Budget")
                .font(StaticAppFonts.largeTitle)
                .foregroundColor(StaticAppColors.primaryAccent)
                .padding(.top, 40)
                .padding(.bottom, 50)

            Text("REGULAR EXPENSES")
                .font(StaticAppFonts.title2.weight(.bold))
                .foregroundColor(StaticAppColors.primaryAccent)
                .padding(.bottom, 20)
        }
    }
}

struct StaticAddExpenseButtonView: View {
    @Binding var isPresentingAddExpenseSheet: Bool

    var body: some View {
        Button(action: { isPresentingAddExpenseSheet = true }) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 32, height: 32)
                    .foregroundColor(StaticAppColors.primaryAccent)
                Text("ADD EXPENSE")
                    .font(StaticAppFonts.headline.weight(.bold))
                    .foregroundColor(StaticAppColors.primaryText)
            }
        }
        .padding(.bottom, 25)
    }
}

struct StaticExpenseListBoxView: View {
    @ObservedObject var appData: AppDataManager

    var body: some View {
        Group {
            if appData.data.regularExpenditures.isEmpty {
                VStack(spacing: 0) {
                    StaticExpensePlaceholderRowView(text: "Mortgage payment, rent, electricity, water, internet, gym")
                }
            } else {
                List {
                    ForEach(appData.data.regularExpenditures) { expense in
                        StaticExpenseRowView(expense: expense)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(StaticAppColors.secondaryBackground)
                    }
                    .onDelete(perform: appData.removeRegularExpenditure)
                    .listRowSeparator(.hidden)

                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .background(StaticAppColors.secondaryBackground)
            }
        }
        .frame(minHeight: 160, maxHeight: 220)
        .background(StaticAppColors.secondaryBackground)
        .cornerRadius(StaticStyleConstants.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: StaticStyleConstants.cornerRadius)
                .stroke(StaticAppColors.secondaryText.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal, 30)
    }
}

struct StaticExpensePlaceholderRowView: View {
    var text: String? = nil

    var body: some View {
        HStack {
            if let text = text {
                Text(text)
                    .font(StaticAppFonts.subheadline)
                    .foregroundColor(StaticAppColors.placeholder)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 12)
            } else {
                Spacer().frame(height: 1)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(StaticAppColors.secondaryBackground)
    }
}

struct StaticExpenseRowView: View {
    let expense: ExpenditureItem

    var recurrenceText: String {
        if let recurrence = ExpenseRecurrence.allCases.first(where: { $0.days == expense.expenditurePeriod }) {
            return "\(recurrence.rawValue)"
        } else {
            return "Every \(expense.expenditurePeriod) days"
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.expenditureName)
                    .font(StaticAppFonts.body.weight(.medium))
                    .foregroundColor(StaticAppColors.primaryText)
                Text(recurrenceText)
                    .font(StaticAppFonts.caption)
                    .foregroundColor(StaticAppColors.secondaryText)
            }
            Spacer()
            Text(ConvertValue.FloatToCurrency(floatVal: expense.expenditureAmount))
                .font(StaticAppFonts.body.weight(.medium))
                .foregroundColor(StaticAppColors.primaryText)
        }
        .background(StaticAppColors.secondaryBackground)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

struct StaticCustomListDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(StaticAppColors.secondaryText.opacity(0.3))
    }
}
