//
//  HMButton.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/8/25.
//  增加背景颜色支持

import UIKit

class HMButton: UIButton {
    var highlightColor: UIColor?
    var normalColor: UIColor?
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightColor : normalColor
        }
    }

    func setBackgroundColor(color: UIColor, state: UIControl.State) {
        if state == .highlighted {
            highlightColor = color
        }
        if state == .normal {
            normalColor = color
        }
    }
    func setColor(normal: UIColor, highlighted: UIColor) {
        highlightColor = highlighted
        normalColor = normal
        isHighlighted = false
        
    }
}
