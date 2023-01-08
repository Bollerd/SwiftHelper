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
}
