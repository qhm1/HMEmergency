//
//  HMColorManager.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/28.
//

import UIKit

extension UIColor {
    class func hexColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension CALayer {
    func skt_setShadow(color: UIColor? = .black,
                       alpha: CGFloat = 0.5,
                       x: CGFloat = 0, y: CGFloat = 2,
                       blur: CGFloat = 4,
                       spread: CGFloat = 0) {
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur * 0.5
        shadowColor = color?.cgColor
        shadowOpacity = Float(alpha)

        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        shadowPath = path.cgPath
    }
}

extension CALayer {
    func commonStyle() {
        skt_setShadow(color: UIColor.black, alpha: 0.07, x: 1, y: 0, blur: 5, spread: 2)
        cornerRadius = 9
    }
}

class HMColorManager {
    var MainColor:UIColor = UIColor.hexColor(hex: "#2EC4B6")
    var SecondColor:UIColor = UIColor.hexColor(hex: "#CBF3F0")
    var blueWrite:UIColor = UIColor.hexColor(hex: "#E3EAF2")
    var greenWrite:UIColor = UIColor.hexColor(hex: "#EFF9F9")
    var textBlack:UIColor = UIColor.hexColor(hex: "#27303F")
    var textgray:UIColor = UIColor.hexColor(hex: "#B5B5B5")
}

let shareColor = HMColorManager()
