import SwiftUI

struct AppSettings: View {
    @ObservedObject var appManager: AppManager
    
    @State private var budgetAmountText = ""
    @State private var budgetPeriodText = ""
    @State private var saveGoalAmountText = ""
    
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    Button(action: CloseSettings) {
                        Text("Close")
                            .font(.system(size: 24))
                            .padding(.top, 10.0)
                            .padding(.leading, 30.0)
                    }
                    Spacer()
                }
                Text("Settings")
                    .font(.system(size: 48))
                    .fontWeight(Font.Weight.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5.0)
                
                Spacer()
            }
        }
        .onDisappear() { appManager.appData.Save() }
    }
    
    func CloseSettings(){
        appManager.menuState = .mainMenu
    }
    
    func ResetApp(){
        appManager.Reset()
    }
}
