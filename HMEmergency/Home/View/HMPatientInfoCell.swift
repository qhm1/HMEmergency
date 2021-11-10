//
//  HMPatientInfoCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/6.
//

import UIKit
import Reusable

class HMPatientInfoCell: UICollectionViewCell, Reusable {
    
    let titles = ["男","女","青少年","中老年","清醒","昏迷",]
    
    let topBar = HMCellTopBar(image: UIImage(named: "定位"), title: "患者信息")
    
    let selectBar = HMSelectBar()
    weak var superVC: HMSelectInfo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.layer.commonStyle()
        selectBar.myDataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let w = HMwidth-20
//        let h = (titles.count+1/2)*70
//        setNeedsLayout()
//        layoutIfNeeded()
//        layoutAttributes.frame.size.width = w
//        layoutAttributes.frame.size.height = CGFloat(h)
//        return layoutAttributes
//    }
    
    func setUI() {
        addSubview(topBar)
        addSubview(selectBar)
        topBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        
        selectBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        
    }
    
    //计算size高度
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let h: Int = (titles.count+1)/2
        layoutAttributes.frame.size.height = CGFloat(50 + 70*h)
        return layoutAttributes
    }
    
    func load() {
        setUI()
    }
}

extension HMPatientInfoCell: HMSelectBarDataSource {
    func selectMessage(index: Int) {
        let message = titles[index]
        superVC?.pushMessage.append(message)
    }
    
    func cellCount()->Int {
        return titles.count
    }
    
    func title(index: Int) ->String {
        return titles[index]
    }
    
    
}
