//
//  HMFindViewController.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/27.
//

import UIKit
import Reusable
import AEAlertView

class HMFindViewController: UIViewController {
    
    lazy var CardsData:[UIImage?] = {
        return [UIImage(named: "健康救助站"),UIImage(named: "救助者计划")]
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(cellType: HMFindCollectionViewCell.self)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = shareColor.greenWrite
        self.title = "发现"
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage(named: "发现")
        setUI()
    }
    
    func setUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension HMFindViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CardsData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMFindCollectionViewCell.self)
        cell.load(image: CardsData[indexPath.row]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth-20, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(HMHealthStationVC(), animated: true)
            AEAlertView.show(title: "提示", actions: ["确定"], message: "本界面由政府或民间组织提供服务", handler: nil)
        case 1:
            self.navigationController?.pushViewController(HMHelperPlanVC(), animated: true)
        default:
            print("index:\(indexPath.row)")
        }
    }
}

let HMwidth = UIScreen.main.bounds.width
let HMheight = UIScreen.main.bounds.height
