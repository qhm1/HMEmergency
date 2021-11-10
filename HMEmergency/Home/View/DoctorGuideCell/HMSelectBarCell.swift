//
//  HMSelectBarCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/2.
//

import UIKit
import Reusable

class HMSelectBarCell: UICollectionViewCell, Reusable {
    var titleText: String!
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String) {
        self.titleText = title
        self.titleLabel.text = title
        self.backgroundColor = UIColor.hexColor(hex: "#efefef")
        setUI()
    }
    
    func setUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
