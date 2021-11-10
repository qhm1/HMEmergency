//
//  HMFindCollectionViewCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/28.
//

import UIKit
import Reusable

class HMFindCollectionViewCell: UICollectionViewCell, Reusable{
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        setUI()
    }
    
    func setUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}
