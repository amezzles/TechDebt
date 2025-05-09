import SwiftUI

struct GetStarted: View {
    @ObservedObject var appManager: AppManager
    
    var body: some View {
        ZStack{
            Text("\(CurrencyFormatter.FloatToCurrency(floatVal: appManager.appData.data.budgetAmount))")
        }
    }
}
