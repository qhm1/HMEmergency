//
//  HMHomeMapCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/2.
//

import UIKit
import Reusable


class HMHomeMapCell: UICollectionViewCell,Reusable {
    let map = MAMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let topBar = HMCellTopBar(image: UIImage(named: "定位"), title: "定位成功")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        map.delegate = self
        self.backgroundColor = UIColor.white
        self.layer.commonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load() {
        setUI()
        map.isShowsUserLocation = true
        map.userTrackingMode = .follow
        AMapServices.shared().enableHTTPS = true
    }
    
    func setUI() {
        addSubview(topBar)
        addSubview(map)
        topBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        
        map.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(topBar.snp.bottom)
        }
    }
    
    //preferredLayoutAttributesFittingAttributes
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let w = HMwidth-20
        let h = 300
        setNeedsLayout()
        layoutIfNeeded()
        layoutAttributes.frame.size.width = w
        layoutAttributes.frame.size.height = CGFloat(h)
        return layoutAttributes
    }
    
}

extension HMHomeMapCell: MAMapViewDelegate {
    
}
