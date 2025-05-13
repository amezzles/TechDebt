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
                .font(StaticAppFonts.largeTitle)
                .foregroundColor(StaticAppColors.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Let's get your finances organized. Tap below to begin setting up your budget.")
                .font(StaticAppFonts.headline)
                .foregroundColor(StaticAppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
            Spacer()

            Button(action: {
                appManager.menuState = .sBudgetDetails
            }) {
                Text("Get Started")
                    .staticPrimaryButtonStyle()
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .padding(StaticStyleConstants.standardPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(StaticAppColors.primaryBackground.edgesIgnoringSafeArea(.all))
        .onAppear {
            print("GetStarted view appeared.")
             print("Static Primary Background: \(String(describing: StaticAppColors.primaryBackground))")
             print("Static Primary Text: \(String(describing: StaticAppColors.primaryText))")
        }
    }
}
