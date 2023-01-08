import Foundation

public extension Decimal {
    func rounded(_ roundingMode: NSDecimalNumber.RoundingMode = .bankers) -> Decimal {
        var result = Decimal()
        var number = self
        NSDecimalRound(&result, &number, 0, roundingMode)
        return result
    }
    var whole: Decimal { self < 0 ? rounded(.up) : rounded(.down) }
    var fraction: Decimal { self - whole }

    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
    var IntValue:Int {
        return NSDecimalNumber(decimal:self).intValue
    }
}


//TODO add textValue like for Int class