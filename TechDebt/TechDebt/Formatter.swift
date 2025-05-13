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

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme() // Provide a default theme
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

struct AppColors {
    let primaryAccent = Color("PrimaryAccent")
    let primaryBackground = Color("PrimaryBackground")
    let secondaryBackground = Color("SecondaryBackground")

    // Text colors
    let primaryText = Color("PrimaryText")
    let secondaryText = Color("SecondaryText")
    let accentText = Color("AccentText")

    // Semantic colors
    let error = Color.red
    let success = Color.green
    let warning = Color.orange
}

struct AppFonts {
    let largeTitle = Font.custom("Kaph-Regular copy", size: 34) // Replace "YourFont-Bold"
    let title1 = Font.custom("Kaph-Regular copy", size: 28)
    let title2 = Font.custom("Kaph-Regular copy", size: 22)
    let headline = Font.custom("Kaph-Regular copy", size: 17)
    let body = Font.custom("Kaph-Regular copy", size: 17)
    let callout = Font.custom("Kaph-Regular copy", size: 16)
    let subheadline = Font.custom("Kaph-Regular copy", size: 15)
    let footnote = Font.custom("Kaph-Regular copy", size: 13)
    let caption = Font.custom("Kaph-Regular copy", size: 12)
}

struct AppTheme {
    let colors = AppColors()
    let fonts = AppFonts()
    let cornerRadius: CGFloat = 10
    let standardPadding: CGFloat = 16
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.appTheme) var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.fonts.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, theme.standardPadding)
            .frame(maxWidth: .infinity)
            .foregroundColor(theme.colors.accentText)
            .background(theme.colors.primaryAccent)
            .cornerRadius(theme.cornerRadius)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct CardBackground: ViewModifier {
    @Environment(\.appTheme) var theme

    func body(content: Content) -> some View {
        content
            .padding(theme.standardPadding)
            .background(theme.colors.secondaryBackground)
            .cornerRadius(theme.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func cardBackgroundStyle() -> some View {
        self.modifier(CardBackground())
    }
}

extension Text {
    func appFont(_ fontStyle: Font, theme: AppTheme, color: Color? = nil) -> Text {
         self
            .font(fontStyle)
            .foregroundColor(color ?? theme.colors.primaryText)
    }

    func headlineStyle(theme: AppTheme) -> Text {
         self.appFont(theme.fonts.headline, theme: theme, color: theme.colors.primaryText)
    }
     func bodyStyle(theme: AppTheme, color: Color? = nil) -> Text {
         self.appFont(theme.fonts.body, theme: theme, color: color ?? theme.colors.secondaryText)
    }
}
