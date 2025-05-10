import Foundation

class ConvertValue {
    static func FloatToCurrency(floatVal: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.maximumFractionDigits = 2
        if floor(floatVal) == floatVal { format.minimumFractionDigits = 0 }
        else { format.minimumFractionDigits = 2 }
        
        return format.string(from: NSNumber(value: floatVal)) ?? "Error: Currency Not Available"
    }
    
    private static let currencyAcceptedVals = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    static func CurrencyToFloat(stringVal: String) -> Float {
        var newString = ""
        for character in stringVal {
            if currencyAcceptedVals.contains(String(character))  { newString.append(character) }
        }
        return Float(newString) ?? 0.0
    }
    
    static func IntToDays(intVal: Int) -> String {
        return "\(intVal) Days"
    }
    
    private static let periodAcceptedVals = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static func DaysToInt(stringVal: String) -> Int {
        
        var newString = ""
        for character in stringVal {
            if periodAcceptedVals.contains(String(character))  { newString.append(character) }
        }
        return Int(newString) ?? 0
    }
}
