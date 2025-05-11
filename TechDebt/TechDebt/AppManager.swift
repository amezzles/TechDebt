import SwiftUI

enum MenuState { case getStarted, sBudgetAmount, sBudgetPeriod, sRegularExpenditure, sSavingGoal, mainMenu, settings, regularExpenditure, transactionHistory }

final class AppManager: ObservableObject {
    static let instance = AppManager()
    var appData: AppDataManager = AppDataManager.instance

        @Published var menuState: MenuState

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
}
