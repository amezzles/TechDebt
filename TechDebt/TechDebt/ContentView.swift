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
            case .home: MainMenu(appManager: manager)
        }
    }
}

#Preview {
    ContentView()
}
