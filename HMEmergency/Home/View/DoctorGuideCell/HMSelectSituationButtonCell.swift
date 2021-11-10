//
//  HMSelectSituationButtonCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/9.
//

import UIKit
import Reusable

class HMSelectSituationButtonCell: UICollectionViewCell, Reusable {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = shareColor.blueWrite
        self.contentView.layer.cornerRadius = 10
        self.titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String, highLight: Bool) {
        titleLabel.text = title
        if highLight == true {
            self.contentView.backgroundColor = shareColor.MainColor
        } else {
            self.contentView.backgroundColor = shareColor.blueWrite
        }
        setUI()
    }
    
    func setUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
}
