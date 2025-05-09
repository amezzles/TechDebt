import SwiftUI

enum MenuState { case getStarted, sBudgetAmount, sBudgetPeriod, sRegularExpenditure, sSavingGoal, mainMenu, settings, regularExpenditure, transactionHistory }

final class AppManager: ObservableObject {
    static var instance = AppManager()
    private init() {
        if(!appData.data.hasSet) { menuState = .settings }
    }
    
    @Published var menuState: MenuState = .mainMenu
    @Published var appData: AppDataManager = AppDataManager()
    
    func Reset(){
        appData.Reset()
        menuState = .getStarted
    }
}
