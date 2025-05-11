import SwiftUI

final class AppDataManager: ObservableObject {
    static let instance = AppDataManager()
    public init() { Load() }
    
    private let SaveKey = "TechDebt"
    
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
    
    func SetBudgetAmount(stringVal: String) -> String {
        data.budgetAmount = ConvertValue.CurrencyToFloat(stringVal: stringVal)
        Save()
        return ConvertValue.FloatToCurrency(floatVal: data.budgetAmount)
    }
    
    func SetBudgetRemaining(stringVal: String) -> String {
        data.budgetRemaining = ConvertValue.CurrencyToFloat(stringVal: stringVal)
        Save()
        return ConvertValue.FloatToCurrency(floatVal: data.budgetRemaining)
    }
    
    func SetBudgetRemainingAfterTransaction(stringVal: String) -> String {
        data.budgetRemaining -= ConvertValue.CurrencyToFloat(stringVal: stringVal)
        Save()
        return ConvertValue.FloatToCurrency(floatVal: data.budgetRemaining)
    }
    
    func SetBudgetPeriod(stringVal: String) -> String {
        let budgetPeriod = ConvertValue.DaysToInt(stringVal: stringVal)
        if budgetPeriod <= 0 {
            return ConvertValue.IntToDays(intVal: data.budgetPeriod)
        }
        data.budgetPeriod = budgetPeriod
        Save()
        return ConvertValue.IntToDays(intVal: data.budgetPeriod)
    }
    
    func SetSaveGoalAmount(stringVal: String) -> String {
        data.saveAmount = ConvertValue.CurrencyToFloat(stringVal: stringVal)
        Save()
        return ConvertValue.FloatToCurrency(floatVal: data.saveAmount)
    }
    
    func SetSaveGoalText(stringVal: String) -> String {
        data.saveGoalText = stringVal
        Save()
        return data.saveGoalText
    }
    
}

struct AppData : Codable {
    var budgetAmount: Float = 0.0
    var budgetRemaining: Float = 0.0
    var budgetPeriod: Int = 0
    var saveAmount: Float = 0.0
    var saveGoalText: String = ""
    var regularExpenditures: [ExpenditureItem] = []
    var hasSet = false
}

struct ExpenditureItem: Codable {
    var expenditureName: String = ""
    var expenditureAmount: Float = 0.0
    var expenditurePeriod: Int = 0
    var expenditureAmountPerBudgetPeriod: Float = 0.0
    
    mutating func SetExpenditureForBudget(period: Int) {
        expenditureAmountPerBudgetPeriod = (expenditureAmount / Float(expenditurePeriod)) * Float(period)
    }
}
