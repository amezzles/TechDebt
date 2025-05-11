import SwiftUI

enum MenuState { case getStarted, sBudgetAmount, sBudgetPeriod, sRegularExpenditure, sSavingGoal, mainMenu, settings, regularExpenditure, transactionHistory, addTransaction }

final class AppManager: ObservableObject {
    static var instance = AppManager()
    init() {
        if(!appData.data.hasSet) { menuState = .getStarted }
    }
    
    @Published var menuState: MenuState = .mainMenu
    var appData: AppDataManager = AppDataManager.instance
    
    func Reset(){
        appData.Reset()
        menuState = .getStarted
    }
}
