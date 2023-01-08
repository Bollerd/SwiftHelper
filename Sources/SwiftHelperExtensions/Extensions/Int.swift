public extension Int {
    var textValue: String {
        get {
            return "\(self)"
        }
        set {
            guard let intValue = Int(newValue) else {
                self = 0
                return
            }
            self = intValue
        }
    }
}
