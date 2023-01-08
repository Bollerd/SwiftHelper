import Foundation
import SwiftUI

public struct she {
    public init() {
    }
    
    /// translate a text from localizable strings file
    /// - Parameter keyText: key text of the text to be translated from localizable file
    /// - Parameter variables: array of strings with variable text parts to put into the translation string
    /// - Returns: translated text
    public static func translateText(keyText: String, variables: [String]) -> String {
        let textInLanguage = NSLocalizedString("\(keyText)", comment: "")
        
        var replacedWithPlaceholders = ""
        
        switch variables.count {
        case 1:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables[0])
        case 2:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables[0],variables[1])
        case 3:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables[0],variables[1],variables[2])
        default:
            replacedWithPlaceholders = String.localizedStringWithFormat(textInLanguage,variables)
        }
        
        return replacedWithPlaceholders
    }


    /// translate a text from localizable strings file
    /// - Parameter keyText: key text of the text to be translated from localizable file
    /// - Returns: translated text
    public static func translateText(keyText: String) -> String {
        return NSLocalizedString("\(keyText)", comment: "")
    }
    
    public static func testLocalization() -> String {
        return she.translateText(keyText: "Test")
    }
}


