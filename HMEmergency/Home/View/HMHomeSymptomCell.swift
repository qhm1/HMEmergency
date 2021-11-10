//
//  HMHomeSymptomCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/2.
//
// 选择情况

import UIKit
import Reusable

protocol HMHomeSymptomCellDelegate {
    func selectSituation(situation: titlesModel)
}

class HMHomeSymptomCell: UICollectionViewCell,Reusable {
    
    weak var collectionView: UICollectionView?
    var isExpand: Bool?
    let titles: [String] = symptom
    var situationTitles: [titlesModel] = []
    var delegate: HMHomeSymptomCellDelegate?
    
    private let topBar = HMCellTopBar(image: UIImage(named: "定位"), title: "选择症状")
    private let selectBar = HMSelectBar()
    private let exButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isExpand = false
        selectBar.myDataSource = self
        selectBar.isScrollEnabled = false
        self.layer.commonStyle()
        exButton.setTitle("展开", for: .normal)
        exButton.addTarget(self, action: #selector(exButtonDidTouch), for: .touchUpInside)
        exButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(titles: [titlesModel]) {
        setUI()
        self.situationTitles = titles
        selectBar.reloadData()
    }
    
    
    func setUI() {
        addSubview(topBar)
        backgroundColor = UIColor.white
        addSubview(selectBar)
        addSubview(exButton)
        
        topBar.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.equalToSuperview().offset(-100)
        }
        
        selectBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        
        exButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(topBar)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    @objc func exButtonDidTouch() {
        print("exbutton did touch")
        if isExpand == true {
            isExpand = false
            exButton.setTitle("展开", for: .normal)
        } else {
            isExpand = true
            exButton.setTitle("关闭", for: .normal)
        }
        UIView.transition(with: collectionView!, duration: 0.8, options: .allowAnimatedContent) {
            self.contentView.frame.size.height = CGFloat(self.caculateHeight())
        } completion: { _ in
        }
        self.collectionView?.reloadData()
    }
    
    //计算size高度
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let h: Int = (titles.count+1)/2
        if h>2 && isExpand == false {
            layoutAttributes.frame.size.height = 200
        } else {
            layoutAttributes.frame.size.height = CGFloat(50 + 70*h)
        }
        return layoutAttributes
    }
    
    func caculateHeight() -> Int{
        let h: Int = (titles.count+1)/2
        let height: Int
        if h>2 && isExpand == false {
            height = 200
        } else {
            height = 50 + 70*h
        }
        return height
    }
}

extension HMHomeSymptomCell: HMSelectBarDataSource {
    func selectMessage(index: Int) {
        self.delegate?.selectSituation(situation: situationTitles[index])
    }
    
    func cellCount()->Int {
        return situationTitles.count
    }
    func title(index: Int) ->String {
        return situationTitles[index].name
    }
    
}
