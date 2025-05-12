import SwiftUI

enum ExpenseRecurrence: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biWeekly = "Bi-Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"

    var id: String { self.rawValue }

    var days: Int {
        switch self {
        case .daily:
            return 1
        case .weekly:
            return 7
        case .biWeekly:
            return 14
        case .monthly:
            return 30
        case .quarterly:
            return 90

        case .yearly:
            return 365
        }
    }
}

enum BudgetCycle: String, Codable, CaseIterable, Identifiable {
    case weekly = "Weekly"
    case biWeekly = "Bi-Weekly"
    case monthly = "Monthly"

    var id: String { self.rawValue }

    var days: Int {
        switch self {
        case .weekly: return 7
        case .biWeekly: return 14
        case .monthly: return 30
        }
    }
}

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
        data.saveGoalAmount = ConvertValue.CurrencyToFloat(stringVal: stringVal)
        Save()
        return ConvertValue.FloatToCurrency(floatVal: data.saveGoalAmount)
    }
    
    func SetSaveGoalText(stringVal: String) -> String {
        data.saveGoalText = stringVal
        Save()
        return data.saveGoalText
    }
    
    func setBudgetName(_ name: String) {
            data.budgetName = name
        }

    func setBudgetCycle(_ cycle: BudgetCycle) {
        data.budgetCycle = cycle
        data.budgetPeriod = cycle.days
        recalculateBudgetAmountPerPeriod()
    }

    func setBudgetStartDate(_ date: Date) {
        data.budgetStartDate = date
    }

    func setYearlyEarnings(stringVal: String) {
        data.yearlyEarnings = ConvertValue.CurrencyToFloat(stringVal: stringVal)
        recalculateBudgetAmountPerPeriod()
    }

    func getYearlyEarningsString() -> String {
        return ConvertValue.FloatToCurrency(floatVal: data.yearlyEarnings)
    }
    
    func finalizeBudgetDetails() {
        recalculateBudgetAmountPerPeriod()
    }
    
    private func recalculateBudgetAmountPerPeriod() {
        guard data.yearlyEarnings > 0 else {
            data.budgetAmount = 0
            return
        }

        let periodsInYear: Float
        switch data.budgetCycle {
        case .weekly:
            periodsInYear = 365.25 / 7.0
        case .biWeekly:
            periodsInYear = 365.25 / 14.0
        case .monthly:
            periodsInYear = 12.0
        }
        data.budgetAmount = data.yearlyEarnings / periodsInYear
    }

    func removeRegularExpenditure(at offsets: IndexSet) {
        data.regularExpenditures.remove(atOffsets: offsets)
        Save()
    }
}

struct AppData : Codable {
    var budgetName: String = ""
    var budgetCycle: BudgetCycle = .monthly
    var budgetStartDate: Date = Date()
    var yearlyEarnings: Float = 0.0
    
    // Amount you have in the budget calculated from yearly earnings/budget period
    var budgetAmount: Float = 0.0
    
    var budgetRemaining: Float = 0.0
    
    // Budget cycle in days
    var budgetPeriod: Int = 0
    var saveGoalAmount: Float = 0.0
    var saveGoalText: String = ""
    var currentSaveAmount: Float = 0.0
    var regularExpenditures: [ExpenditureItem] = []
    var hasSet = false
}

struct ExpenditureItem: Codable, Identifiable {
    var id = UUID()
    var expenditureName: String = ""
    var expenditureAmount: Float = 0.0
    var expenditurePeriod: Int = 0
    var expenditureAmountPerBudgetPeriod: Float = 0.0

    mutating func SetExpenditureForBudget(period: Int) {
        if expenditurePeriod > 0 {
            expenditureAmountPerBudgetPeriod = (expenditureAmount / Float(expenditurePeriod)) * Float(period)
        } else {
            expenditureAmountPerBudgetPeriod = 0
        }
    }

    init(id: UUID = UUID(), expenditureName: String = "", expenditureAmount: Float = 0.0, expenditurePeriod: Int = 0, expenditureAmountPerBudgetPeriod: Float = 0.0) {
        self.id = id
        self.expenditureName = expenditureName
        self.expenditureAmount = expenditureAmount
        self.expenditurePeriod = expenditurePeriod
        self.expenditureAmountPerBudgetPeriod = expenditureAmountPerBudgetPeriod
    }
}
