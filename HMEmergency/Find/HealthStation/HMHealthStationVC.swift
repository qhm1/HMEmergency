//
//  HMHealthStationVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/4.
//

import UIKit
import AEAlertView

class HMHealthStationVC: UIViewController {
    private var images:[UIImage]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: HMFindCollectionViewCell.self)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = shareColor.greenWrite
        self.title = "发现"
        images = HealthStationCardImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.tabBarItem.image = UIImage(named: "发现")
    }
    
    
    func setUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}

extension HMHealthStationVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMFindCollectionViewCell.self)
        cell.load(image: images![indexPath.row])
        return cell
    }
    
    //delegate flowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth-20, height: (HMwidth-20)/1.6)
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("index: \(indexPath.row)")
            self.navigationController?.pushViewController(HMHandbookVC(), animated: true)
        case 1:
            print("index: \(indexPath.row)")
            //self.navigationController?.pushViewController(HMVisitingServiceVC(), animated: true)
            self.navigationController?.pushViewController(HMHelperListVC(), animated: true)
        default:
            print("index: \(indexPath.row)")
        }
    }
}
