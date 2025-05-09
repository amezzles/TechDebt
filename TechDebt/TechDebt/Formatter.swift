import Foundation

class CurrencyFormatter {
    static func FloatToCurrency(floatVal: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.maximumFractionDigits = 2
        if floor(floatVal) == floatVal { format.minimumFractionDigits = 0 }
        else { format.minimumFractionDigits = 2 }
        
        return format.string(from: NSNumber(value: floatVal)) ?? "Error: Currency Not Available"
    }
    
    static func CurrencyToFloat(stringVal: String) -> Float {
        let floatValue = Float(stringVal.replacingOccurrences(
            of: "[^0-9.]",
            with: ""
        ))
        return floatValue ?? 0.0
    }
}
