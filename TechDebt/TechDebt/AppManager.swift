import SwiftUI

enum MenuState { case getStarted, sBudgetDetails, sRegularExpenditure, sSavingGoal, mainMenu, settings, transactionHistory, addTransaction}

final class AppManager: ObservableObject {
    static let instance = AppManager()
    var appData: AppDataManager = AppDataManager.instance

    @Published var menuState: MenuState = .mainMenu

    private init() {
        if !self.appData.data.hasSet {
            self.menuState = .getStarted
        } else {
            self.menuState = .mainMenu
        }
    }

    func Reset(){
        appData.Reset()
        menuState = .getStarted
    }
    
    
    var budgetTimer: Timer?
    func BeginBudget() {
        budgetTimer?.invalidate()
        budgetTimer = nil
        
        appData.data.budgetRemaining = appData.data.budgetAmount
        var regularExpenditureTotal: Float = 0
        for var expItem in appData.data.regularExpenditures {
            expItem.SetExpenditureForBudget(period: appData.data.budgetPeriod)
            regularExpenditureTotal += expItem.expenditureAmountPerBudgetPeriod
        }
        appData.data.budgetRemaining -= regularExpenditureTotal
        
        
        if let firstTurnover = Calendar.current.date(byAdding: .day, value: appData.data.budgetPeriod, to: appData.data.budgetStartDate) {
            let interval = firstTurnover.timeIntervalSinceNow
            if interval > 0 {
                budgetTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                    self.TurnoverBudget()
                }
            } else {
                budgetTimer = Timer.scheduledTimer(withTimeInterval: Date.now.timeIntervalSinceNow, repeats: false) { _ in
                    self.TurnoverBudget()
                }
            }
        }
    }
    
    func TurnoverBudget() {
        budgetTimer?.invalidate()
        budgetTimer = nil
        
        appData.data.currentSaveAmount += appData.data.budgetRemaining
        appData.data.budgetRemaining = appData.data.budgetAmount
        var regularExpenditureTotal: Float = 0
        for var expItem in appData.data.regularExpenditures {
            expItem.SetExpenditureForBudget(period: appData.data.budgetPeriod)
            regularExpenditureTotal += expItem.expenditureAmountPerBudgetPeriod
        }
        appData.data.budgetRemaining -= regularExpenditureTotal
        
        if let nextTurnover = Calendar.current.date(byAdding: .day, value: appData.data.budgetPeriod, to: appData.data.budgetStartDate) {
            let interval = nextTurnover.timeIntervalSinceNow
            if interval > 0 {
                budgetTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                    self.TurnoverBudget()
                }
            }
        }
    }
}
