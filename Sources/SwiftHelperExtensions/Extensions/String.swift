import Foundation

public extension String.StringInterpolation {
    /// String Interpolation for SwiftUI
    /// - Parameters:
    ///   - number: Int to be returned as String
    ///   - style: Number formatter 
    mutating func appendInterpolation(_ number: Int, style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style

        if let result = formatter.string(from: number as NSNumber) {
            appendLiteral(result)
        }
    }
}

