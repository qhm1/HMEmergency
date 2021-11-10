//
//  HMLoginViewCell.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/8/27.
//

import UIKit

class HMLoginViewCell: UIView {
    let label = UILabel()
    let text = UITextField()
    let line = UIView()
    
    init(left: String, right: String) {
        super.init(frame: CGRect())
        label.text = left
        text.placeholder = right
        
        line.backgroundColor = shareColor.textgray
        line.alpha = 0.2
        addSubview(label)
        addSubview(text)
        addSubview(line)
    }
    
    override func layoutSubviews() {
        self.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: HMwidth-70, height: 50))
        }
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        text.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(90)
            make.width.greaterThanOrEqualTo(HMwidth-100)
        }
        line.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
