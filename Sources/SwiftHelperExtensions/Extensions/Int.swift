public extension Int {
    /// wrapper for SwiftUI to set and read an Int with a TextEdit fields
    var textValue: String {
        get {
            return "\(self)"
        }
        set {
            // in case we can't set the Int Value, we assume the value entered from the user is not
            // only a number and we adjust the value to 0
            guard let intValue = Int(newValue) else {
                self = 0
                return
            }
            self = intValue
        }
    }
}
