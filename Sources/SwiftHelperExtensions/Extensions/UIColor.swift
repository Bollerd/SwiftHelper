import UIKit

public extension UIColor {
    /// get back the color values for red, green, blue and alpha channel
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    /// get the xy representation of the rgb color required for deconz rest api (zigbee/hue)
    var xyColor: (x:CGFloat, y: CGFloat) {
        let r = self.rgba.red
        let g = self.rgba.green
        let b = self.rgba.blue
        let a = self.rgba.alpha
        // convert rgb to required xy color format
        let red = (r > 0.04045) ? pow((r + 0.055) / (1.0 + 0.055), 2.4) : (r / 12.92)
        let green = (g > 0.04045) ? pow((g + 0.055) / (1.0 + 0.055), 2.4) : (g / 12.92)
        let blue = (b > 0.04045) ? pow((b + 0.055) / (1.0 + 0.055), 2.4) : (b / 12.92)
        let X = red * 0.649926 + green * 0.103455 + blue * 0.197109
        let Y = red * 0.234327 + green * 0.743075 + blue * 0.022598
        let Z = red * 0.0000000 + green * 0.053077 + blue * 1.035763
        let x = X / (X + Y + Z)
        let y = Y / (X + Y + Z)
        
        return (x, y)
    }

    /// initialize new color from HTML Color Code
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let newColor = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
        return newColor 
    }
}

