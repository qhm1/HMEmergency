//
//  HMMineCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/28.
//

import UIKit
import Reusable

class HMMineCell: UICollectionViewCell, Reusable {
    
    private let imageView = UIImageView()
    let titleLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = UIColor.white
        titleLable.font = UIFont(name: "Helvetica-Bold", size: 22)
        self.layer.skt_setShadow(color: UIColor.black, alpha: 0.07, x: 1, y: 0, blur: 5, spread: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(model: HMFindCellModel) {
        titleLable.text = model.title
        imageView.image = model.image
        setUI()
    }
    
    func setUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLable)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
    }
}
