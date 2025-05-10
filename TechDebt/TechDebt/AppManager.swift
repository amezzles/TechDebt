import SwiftUI

enum MenuState { case getStarted, sBudgetAmount, sBudgetPeriod, sRegularExpenditure, sSavingGoal, mainMenu, settings, regularExpenditure, transactionHistory }

final class AppManager: ObservableObject {
    static var instance = AppManager()
    private init() {
        if(!appData.data.hasSet) { menuState = .settings }
    }
    
    @Published var menuState: MenuState = .mainMenu
    var appData: AppDataManager = AppDataManager.instance
    
    func Reset(){
        appData.Reset()
        menuState = .getStarted
    }
}
