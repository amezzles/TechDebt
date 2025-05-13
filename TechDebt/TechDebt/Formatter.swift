import Foundation
import SwiftUI

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

struct StaticAppColors {
    static let primaryAccent = Color.primaryAccent
    static let primaryBackground = Color.primaryBackground
    static let secondaryBackground = Color.secondaryBackground
    static let primaryText = Color.primaryText
    static let secondaryText = Color.secondaryText
    static let accentText = Color.accentText
    static let error = Color.red
    static let success = Color.green
    static let warning = Color.orange
    static let placeholder = Color.placeholder
    static let disabledGray = Color.inactive
}

struct StaticAppFonts {
    static let largeTitle: Font = .largeTitle
    static let title1: Font = .title
    static let title2: Font = .title2
    static let title3: Font = .title3
    static let headline: Font = .headline
    static let body: Font = .body
    static let callout: Font = .callout
    static let subheadline: Font = .subheadline
    static let footnote: Font = .footnote
    static let caption: Font = .caption
    static let caption2: Font = .caption2
}

struct StaticStyleConstants {
    static let cornerRadius: CGFloat = 10
    static let standardPadding: CGFloat = 16
}

struct StaticCardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(StaticStyleConstants.standardPadding)
            .background(StaticAppColors.secondaryBackground)
            .cornerRadius(StaticStyleConstants.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func staticCardStyle() -> some View {
        self.modifier(StaticCardBackground())
    }

    func staticPrimaryButtonStyle(isEnabled: Bool = true) -> some View {
        self
            .font(StaticAppFonts.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, StaticStyleConstants.standardPadding)
            .frame(maxWidth: .infinity)
            .foregroundColor(StaticAppColors.accentText)
            .background(isEnabled ? StaticAppColors.primaryAccent : StaticAppColors.disabledGray)
            .cornerRadius(StaticStyleConstants.cornerRadius)
            .opacity(isEnabled ? 1.0 : 0.7)
    }
}
