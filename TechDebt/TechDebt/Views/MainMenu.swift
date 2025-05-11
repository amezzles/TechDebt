import SwiftUI
import Charts

struct MainMenu: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var appData: AppDataManager
    
    var body: some View {
        VStack {
            Text("MainMenu")
                .padding()

            Chart {
                ForEach(appData.regularExpenditures) { item in
                    SectorMark(
                        angle: .value("Expenditure", item.amount),
                        name: item.name
                    )
                    .foregroundStyle(Color.random) 
                }
            }
            .padding()

            Text("Budget Remaining: \(appData.budgetRemaning, specifier: "%.2f")") //.2f to keep budget remaining as currency
                .padding()
        }
    }
}
