import SwiftUI
import Charts

struct MainMenu: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

    private var chartValues: [Slice] {
        var tempChart: [Slice] = []
        var cumulativeAmount: Float = 0

        // Regular Expenditures
        for item in appData.data.regularExpenditures {
            let amount = max(0, item.expenditureAmountPerBudgetPeriod)
            if amount > 0 {
                tempChart.append(Slice(name: item.expenditureName, previous: cumulativeAmount, next: cumulativeAmount + amount))
                cumulativeAmount += amount
            }
        }

        // Other Spending
        let totalBudget = max(0, appData.data.budgetAmount)
        let remainingClamped = appData.data.budgetRemaining
        let totalSpent = totalBudget - remainingClamped
        let sumOfRegularExpenses = tempChart.reduce(0) { $0 + ($1.next - $1.previous) }
        
        let otherSpending = max(0, totalSpent - sumOfRegularExpenses)

        if otherSpending > 0 {
            tempChart.append(Slice(name: "Other Transactions", previous: cumulativeAmount, next: cumulativeAmount + otherSpending))
            cumulativeAmount += otherSpending
        }

        // Budget Remaining
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
        VStack(spacing: 20) {
            Text("Budget Remaining")
            Chart(chartValues) { chartSlice in
                SectorMark(angle: .value("Expenditure", chartSlice.previous..<chartSlice.next))
                    .foregroundStyle(by: .value("Category", chartSlice.name))
            }
            .chartBackground { chartProxy in
              GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                  let frame = geometry[anchor]
                    Text("$\(appData.data.budgetRemaining, specifier: "%.2f")").position(x: frame.midX, y: frame.midY)
                }
              }
            }
            ProgressView(value: appData.data.currentSaveAmount, total: appData.data.saveGoalAmount) {
                Text("Save goal progress")
            }
            .padding()

            Spacer()
            Button(action: {
                appManager.menuState = .addTransaction
            }) {
                Text("Add Transaction")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Spacer()

            // nav bar
            HStack {
                Spacer()
                Button(action: {
                    appManager.menuState = .settings
                }) {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                Spacer()
                Button(action: {
                    appManager.menuState = .mainMenu
                }) {
                    VStack {
                        Image(systemName: "house")
                        Text("Overview")
                    }
                }
                Spacer()
                Button(action: {
                    appManager.menuState = .addTransaction
                }) {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Budget")
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
    }
}
