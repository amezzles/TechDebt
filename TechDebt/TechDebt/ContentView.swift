//
//  ContentView.swift
//  TechDebt
//
//  Created by Amy Roche on 2/5/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = AppManager.instance
    
    var body: some View {
        switch manager.menuState
        {
        case .mainMenu: MainMenu(appManager: manager, appData: manager.appData)
        case .getStarted: GetStarted(appManager: manager, appData: manager.appData)
        case .sBudgetAmount: SetBudgetAmountSetup(appManager: manager, appData: manager.appData)
        case .sBudgetPeriod: SetBudgetPeriodSetup(appManager: manager, appData: manager.appData)
        case .sRegularExpenditure: RegularExpendituresSetup(appManager: manager, appData: manager.appData)
        case .sSavingGoal: SavingsGoalSetup(appManager: manager, appData: manager.appData)
        case .settings: AppSettings(appManager: manager, appData: manager.appData)
        case .regularExpenditure: RegularExpenditure(appManager: manager, appData: manager.appData)
        case .transactionHistory: TransactionHistory(appManager: manager, appData: manager.appData)
        case .addTransaction: AddTransaction(appManager: manager, appData: manager.appData)
        }
    }
}

#Preview {
    ContentView()
}
