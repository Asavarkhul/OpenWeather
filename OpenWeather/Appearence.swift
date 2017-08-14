//
//  Appearence.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit

public final class Appearence {
    static func customize() {
        UINavigationBar.appearance().barTintColor = UIColor.appBlue()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        UILabel.appearance().textColor = UIColor.white
    }
}

extension UIColor {
    static func appBlue() -> UIColor {
        return UIColor(hex: "49B9FA")
    }
}

public extension UIColor {
    convenience public init(hex: String) {
        let scanner = Scanner(string: hex)
        
        if (hex.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    convenience public init(decimalRed: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat){
        self.init(red: decimalRed/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    convenience public init?(hexARGB: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        var cleanString = hexARGB
        if hexARGB.hasPrefix("#") {
            let index = hexARGB.characters.index(hexARGB.startIndex, offsetBy: 1)
            cleanString = hexARGB.substring(from: index)
        }
        
        let scanner = Scanner(string: cleanString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) && cleanString.characters.count == 8 {
            red   = CGFloat((hexValue & 0x00FF0000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x0000FF00) >> 16) / 255.0
            blue  = CGFloat((hexValue & 0x000000FF) >> 8)  / 255.0
            alpha = CGFloat(hexValue & 0xFF000000)         / 255.0
            self.init(red:red, green:green, blue:blue, alpha:alpha)
        } else {
            self.init()
            return nil
        }
    }
}
