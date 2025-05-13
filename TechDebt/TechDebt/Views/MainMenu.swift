import SwiftUI
import Charts

struct MainMenu: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

    private var chartValues: [Slice] {
        var tempChart: [Slice] = []
        var cumulativeAmount: Float = 0

        for item in appData.data.regularExpenditures {
            let amount = max(0, item.expenditureAmountPerBudgetPeriod)
            if amount > 0 {
                tempChart.append(Slice(name: item.expenditureName, previous: cumulativeAmount, next: cumulativeAmount + amount))
                cumulativeAmount += amount
            }
        }

        let totalBudget = max(0, appData.data.budgetAmount)
        let remainingClamped = appData.data.budgetRemaining
        let totalSpent = totalBudget - remainingClamped
        let sumOfRegularExpenses = tempChart.reduce(0) { $0 + ($1.next - $1.previous) }
        
        let otherSpending = max(0, totalSpent - sumOfRegularExpenses)

        if otherSpending > 0 {
            tempChart.append(Slice(name: "Other Transactions", previous: cumulativeAmount, next: cumulativeAmount + otherSpending))
            cumulativeAmount += otherSpending
        }

        let remainingForChart = max(0, appData.data.budgetRemaining)
        if remainingForChart > 0 {
             let finalNext = min(totalBudget, cumulativeAmount + remainingForChart)
             if finalNext > cumulativeAmount {
                 tempChart.append(Slice(name: "Budget Remaining", previous: cumulativeAmount, next: finalNext))
             }
        }
        return tempChart
    }

    struct Slice: Identifiable {
        var id = UUID()
        var name = ""
        var previous: Float = 0.0
        var next: Float = 0.0
    }

    init(appManager: AppManager, appData: AppDataManager) {
        self.appManager = appManager
        self.appData = appData
    }

    var body: some View {
        VStack(spacing: StaticStyleConstants.standardPadding) {
            Text("Budget Overview")
                .font(StaticAppFonts.largeTitle)
                .foregroundColor(StaticAppColors.primaryText)
                .padding(.top, StaticStyleConstants.standardPadding)

            if !chartValues.isEmpty && appData.data.budgetAmount > 0 {
                Chart(chartValues) { chartSlice in
                    SectorMark(angle: .value("Expenditure", chartSlice.previous..<chartSlice.next))
                        .foregroundStyle(by: .value("Category", chartSlice.name))
                        .annotation(position: .overlay) {
                             if (chartSlice.next - chartSlice.previous) / appData.data.budgetAmount > 0.05 {
                                 Text(chartSlice.name)
                                     .font(StaticAppFonts.caption2)
                                     .foregroundColor(.white)
                             }
                        }
                }
                .chartLegend(.hidden)
                .frame(height: 250)
                .padding(.horizontal, StaticStyleConstants.standardPadding)
                .chartBackground { chartProxy in
                  GeometryReader { geometry in
                    if let anchor = chartProxy.plotFrame {
                      let frame = geometry[anchor]
                        VStack {
                            Text("Remaining")
                                .font(StaticAppFonts.caption)
                                .foregroundColor(StaticAppColors.secondaryText)
                            Text(ConvertValue.FloatToCurrency(floatVal:appData.data.budgetRemaining))
                                .font(StaticAppFonts.title2)
                                .foregroundColor(StaticAppColors.primaryText)
                        }.position(x: frame.midX, y: frame.midY)
                    }
                  }
                }
            } else {
                Text("No budget data to display or budget is zero.")
                    .font(StaticAppFonts.body)
                    .foregroundColor(StaticAppColors.secondaryText)
                    .padding()
                    .frame(height: 250)
            }


            if appData.data.saveGoalAmount > 0 {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Savings Goal: \(appData.data.saveGoalText)")
                        .font(StaticAppFonts.headline)
                        .foregroundColor(StaticAppColors.primaryText)
                    ProgressView(value: appData.data.currentSaveAmount, total: appData.data.saveGoalAmount) {
                        HStack {
                            Text(ConvertValue.FloatToCurrency(floatVal: appData.data.currentSaveAmount))
                            Spacer()
                            Text(ConvertValue.FloatToCurrency(floatVal: appData.data.saveGoalAmount))
                        }
                        .font(StaticAppFonts.caption)
                        .foregroundColor(StaticAppColors.secondaryText)
                    }
                    .tint(StaticAppColors.primaryAccent)
                }
                .padding(.horizontal, StaticStyleConstants.standardPadding * 2)
                .padding(.vertical, StaticStyleConstants.standardPadding)
            }


            Spacer()
            Button(action: {
                appManager.menuState = .addTransaction
            }) {
                Text("Add Transaction")
                    .staticPrimaryButtonStyle()
            }
            .padding(.horizontal, StaticStyleConstants.standardPadding * 2)


            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    appManager.menuState = .settings
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "gear")
                            .font(StaticAppFonts.title2)
                        Text("Settings")
                            .font(StaticAppFonts.caption)
                    }
                    .foregroundColor(StaticAppColors.primaryAccent)
                    .frame(minWidth: 60)
                }
                Spacer()
                Button(action: {
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                             .font(StaticAppFonts.title2)
                        Text("Overview")
                             .font(StaticAppFonts.caption)
                    }
                    .foregroundColor(StaticAppColors.primaryText)
                    .frame(minWidth: 60)
                }
                Spacer()
                Button(action: {
                    appManager.menuState = .transactionHistory
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                             .font(StaticAppFonts.title2)
                        Text("History")
                             .font(StaticAppFonts.caption)
                    }
                    .foregroundColor(StaticAppColors.primaryAccent)
                    .frame(minWidth: 60)
                }
                Spacer()
            }
            .padding(.vertical, StaticStyleConstants.standardPadding)
            .padding(.horizontal, StaticStyleConstants.standardPadding / 2)
            .background(StaticAppColors.secondaryBackground)
            .cornerRadius(StaticStyleConstants.cornerRadius * 1.5)
            .padding(.horizontal, StaticStyleConstants.standardPadding)
            .padding(.bottom, StaticStyleConstants.standardPadding / 2)
        }
        .background(StaticAppColors.primaryBackground.ignoresSafeArea())
    }
}

#if DEBUG
struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        let appManager = AppManager.instance
        let appData = AppDataManager.instance
        appData.data.budgetName = "Monthly Budget"
        appData.data.budgetAmount = 2000
        appData.data.budgetRemaining = 850.50
        appData.data.regularExpenditures = [
            ExpenditureItem(expenditureName: "Rent", expenditureAmount: 1000, expenditurePeriod: 30, expenditureAmountPerBudgetPeriod: 1000),
            ExpenditureItem(expenditureName: "Groceries", expenditureAmount: 400, expenditurePeriod: 30, expenditureAmountPerBudgetPeriod: 400),
            ExpenditureItem(expenditureName: "Internet", expenditureAmount: 60, expenditurePeriod: 30, expenditureAmountPerBudgetPeriod: 60),
            ExpenditureItem(expenditureName: "Transport", expenditureAmount: 100, expenditurePeriod: 30, expenditureAmountPerBudgetPeriod: 100),
        ]
        appData.data.saveGoalText = "New Laptop"
        appData.data.saveGoalAmount = 1500
        appData.data.currentSaveAmount = 300

        return MainMenu(appManager: appManager, appData: appData)
    }
}
#endif
