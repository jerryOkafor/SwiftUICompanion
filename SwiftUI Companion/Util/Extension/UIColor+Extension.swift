//
//  UIColor+Extension.swift
//  QuizApp - UI
//
//  Created by Jerry Hanks on 16/05/2020.
//  Copyright © 2020 Jerry Okafor. All rights reserved.
//

import UIKit

extension UIColor{
    
    /// Init UIColor from Reg, Green and Blue components with default alpha.
    ///
    /// - Parameters:
    ///   - red: Red component value
    ///   - green: Green Component value
    ///   - blue: Blue Component value
    ///   - a: Alpha component value
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    
    /// Init UIColor from RGB Int with defulr alpha
    ///
    /// - Parameters:
    ///   - rgb: RGB color value
    ///   - a: Alpha Component
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat((rgb & 0xFF)) / 255.0,
            alpha: a
        )
    }
    
    
    /// Init UIColor from Hex String
    ///
    /// - Parameter hex: Hex Value
    convenience init(hex: String){
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        if Scanner(string: hexSanitized).scanHexInt32(&rgb){
            if length == 6 {
                r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgb & 0x0000FF) / 255.0
            } else if length == 8 {
                r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgb & 0x000000FF) / 255.0
            }
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
}
