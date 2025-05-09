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
        case .mainMenu: MainMenu(appManager: manager)
        case .getStarted: GetStarted(appManager: manager)
        case .sBudgetAmount: SetBudgetAmountSetup(appManager: manager)
        case .sBudgetPeriod: SetBudgetPeriodSetup(appManager: manager)
        case .sRegularExpenditure: RegularExpendituresSetup(appManager: manager)
        case .sSavingGoal: SavingsGoalSetup(appManager: manager)
        case .settings: AppSettings(appManager: manager)
        case .regularExpenditure: RegularExpenditure(appManager: manager)
        case .transactionHistory: TransactionHistory(appManager: manager)
        case .addTransaction: AddTransaction(appManager: manager)
        }
    }
}

#Preview {
    ContentView()
}
