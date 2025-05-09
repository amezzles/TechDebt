import SwiftUI

enum MenuState { case getStarted, sBudgetAmount, sBudgetPeriod, sRegularExpenditure, sSavingGoal, mainMenu, settings, regularExpenditure, transactionHistory }

final class AppManager: ObservableObject {
    static var instance = AppManager()
    private init() {
        if(!appData.data.hasSet) { menuState = .getStarted }
    }
    
    @Published var menuState: MenuState = .mainMenu
    @Published var appData: AppDataManager = AppDataManager()
}
