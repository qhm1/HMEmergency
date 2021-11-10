//
//  HMCellTopBar.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/1.
//

import UIKit

class HMCellTopBar: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    init(image: UIImage?, title: String) {
        super.init(frame: CGRect())
        imageView.image = image
        titleLabel.text = title
        //titleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        setUI()
    }
    
    init() {
        super.init(frame: CGRect())
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImage?, title: String) {
        imageView.image = image
        titleLabel.text = title
        //titleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        setUI()
    }
    
    func setUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
    }
    
}
