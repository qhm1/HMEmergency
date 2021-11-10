//
//  HMDGMiniCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/6.
//

import UIKit
import Reusable

class HMDGMiniCell: UICollectionViewCell,Reusable {
    
    let topBar = HMCellTopBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.clear
        topBar.layer.commonStyle()
        self.layer.commonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(title: String) {
        topBar.set(image: UIImage(named: "定位"), title: title)
        setUI()
    }
    
    func setUI() {
        contentView.addSubview(topBar)
        
        topBar.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}
