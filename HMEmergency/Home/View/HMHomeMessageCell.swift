//
//  HMHomeMessageCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/9.
//

import UIKit
import Reusable

class HMHomeMessageCell: UICollectionViewCell,Reusable {
    
    let topbar = HMCellTopBar(image: UIImage(named: "信息"), title: "救助信息")
    let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        //self.contentView.layer.commonStyle()
        self.layer.cornerRadius = 10
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(message: String) {
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        setUI()
        self.setNeedsLayout()
        //messageLabel.backgroundColor = UIColor.red
    }
    
    func setUI() {
        contentView.addSubview(topbar)
        contentView.addSubview(messageLabel)
        
        topbar.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.width.equalTo(HMwidth-20)
            make.height.equalTo(50)
            
        }
        messageLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(topbar.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
//        contentView.snp.makeConstraints { (make) in
//            make.width.equalTo(HMwidth-20)
//        }
        

    }
}

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
     }
}


