//
//  HMCircleButton.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/8/27.
//  圆形选中按钮

import UIKit

class HMCircleButton: UIButton {
    let view = UIView()
    init() {
        super.init(frame: CGRect())
        isSelected = false
        self.addSubview(view)
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 7.5
        view.layer.cornerRadius = 6.5
        self.addTarget(self, action: #selector(touch), for: .touchUpInside)
        view.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        view.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(1)
            make.right.bottom.equalToSuperview().offset(-1)
        }
        self.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }
    
    override var isSelected: Bool {
        didSet{
            view.backgroundColor = isSelected ? shareColor.MainColor : shareColor.blueWrite
        }
    }
    @objc func touch() {
        if isSelected {
            isSelected = false
        } else {
            isSelected = true
        }
    }
}
