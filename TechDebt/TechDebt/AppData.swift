import SwiftUI

final class AppDataManager: ObservableObject {
    static var instance = AppDataManager()
    public init() { Load() }
    
    private let SaveKey = "TechDebt"
    
    @Published var data: AppData = AppData()
    
    func Save()
    {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(data, forKey: SaveKey)
        }
    }
    
    private func Load()
    {
        if let savedData = UserDefaults.standard.data(forKey: SaveKey),
           let decoded = try? JSONDecoder().decode(AppData.self, from: savedData) {
            data = decoded
        }
    }
    
}

struct AppData : Codable {
    var budgetAmount = 0
    var budgetRemaining = 0
    var budgePeriod = 0
    var saveAmount = 0
    var saveGoalText = 0
    var hasSet = false
}
