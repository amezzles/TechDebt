import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = AppManager.instance
    
    var body: some View {
        switch manager.menuState
        {
        case .mainMenu: MainMenu(appManager: manager, appData: manager.appData)
        case .getStarted: GetStarted(appManager: manager, appData: manager.appData)
        case .sBudgetDetails: BudgetSetupDetailsView(appManager: manager, appData: manager.appData)
        case .sRegularExpenditure: RegularExpendituresSetup(appManager: manager, appData: manager.appData)
        case .sSavingGoal: SavingsGoalSetup(appManager: manager, appData: manager.appData)
        case .settings: AppSettings(appManager: manager, appData: manager.appData)
        case .addTransaction: AddTransaction(appManager: manager, appData: manager.appData)
        }
    }
}
