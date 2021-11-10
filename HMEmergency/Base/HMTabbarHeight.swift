//
//  HMTabbarHeight.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/8/23.
//

import UIKit



class HMTabbarHeight: NSObject {
    override init() {
        
    }
    func getBottom() -> CGFloat {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                return CGFloat.zero + 49
              }
              
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                return unwrapedWindow.safeAreaInsets.bottom + 49
              }
        }
        return CGFloat(49)
    }
    func getTop() -> CGFloat {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                return CGFloat.zero
              }
              
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                return unwrapedWindow.safeAreaInsets.top
              }
        }
        return CGFloat(49)
    }
}

let shareSafeArea = HMTabbarHeight()
