//
//  HMDGImageCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/7.
//

import UIKit
import Reusable

class HMDGImageCell: UICollectionViewCell,Reusable {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.frame.size.width = HMwidth-20
        layoutAttributes.frame.size.height = 210
        return layoutAttributes
    }
    
    func setUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
                                                              
    }
    
    func load(imageName: String) {
        let image1 = UIImage(named: imageName)
        imageView.image = image1
        setUI()
    }
    
}
