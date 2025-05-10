import SwiftUI

struct GetStarted: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager
    
    var body: some View {
        ZStack{
            Text("hi")
        }
    }
}
