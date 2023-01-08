import Foundation

public extension FloatingPoint {
    var whole: Self { modf(self).0 }
    var fraction: Self { modf(self).1 }
}

//TODO add textValue like for Int class