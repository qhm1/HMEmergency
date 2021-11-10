//
//  HMBaseCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/2.
//

import UIKit

class HMBaseCell: UICollectionViewCell {
    
    let titles = ["呼叫救援队","呼叫救护车"]

    let topBar = HMCellTopBar(image: UIImage(named: "定位"), title: "是否被困")
    let selectBar = HMSelectBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        selectBar.myDataSource = self
        setUI()
        self.layer.commonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubview(topBar)
        addSubview(selectBar)
        
        topBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        
        selectBar.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.width.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
    }
}


extension HMBaseCell: HMSelectBarDataSource {
    func selectMessage(index: Int) {
        
    }
    
    func cellCount()->Int {
        return 2
    }
    func title(index: Int) ->String {
        return titles[index]
    }
}
