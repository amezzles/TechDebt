import SwiftUI

final class AppDataManager: ObservableObject {
    static var instance = AppDataManager()
    public init() { Load() }
    
    private let SaveKey = "aljokliadhzolyl"
    
    @Published var data: AppData = AppData()
    
    func Save()
    {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: SaveKey)
        }
    }
    
    private func Load()
    {
        if let savedData = UserDefaults.standard.data(forKey: SaveKey),
           let decoded = try? JSONDecoder().decode(AppData.self, from: savedData) {
            data = decoded
        }
    }
    
    func Reset()
    {
        data = AppData()
        Save()
    }
    
}

struct AppData : Codable {
    var budgetAmount: Float = 0.0
    var budgetRemaining: Float = 0.0
    var budgePeriod: Int = 0
    var saveAmount: Float = 0
    var saveGoalText: String = ""
    var hasSet: Bool = false
}
