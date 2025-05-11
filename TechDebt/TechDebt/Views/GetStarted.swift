//
//  GetStarted.swift
//  TechDebt
//
//  Created by Amy Roche on 11/5/2025.
//

import SwiftUI

struct GetStarted: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("WelcomeIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.bottom, 30)

            Text("Welcome to Budgie!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Let's get your finances organized. Tap below to begin setting up your budget.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
            Spacer()

            Button(action: {
                appManager.menuState = .sBudgetAmount
            }) {
                Text("Get Started")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor) // Use your app's accent color
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .onAppear {
            
            print("GetStarted view appeared. User has not set up yet.")
        }
    }
}
