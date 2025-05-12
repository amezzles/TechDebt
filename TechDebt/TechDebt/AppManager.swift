import SwiftUI

enum MenuState { case getStarted, sBudgetDetails, sRegularExpenditure, sSavingGoal, mainMenu, settings, regularExpenditure, transactionHistory, addTransaction}

final class AppManager: ObservableObject {
    static let instance = AppManager()
    var appData: AppDataManager = AppDataManager.instance

    @Published var menuState: MenuState = .mainMenu

        private init() {
            if !self.appData.data.hasSet {
                self.menuState = .settings
            }
        }

        func Reset(){
            appData.Reset()
            menuState = .getStarted
        }
}
