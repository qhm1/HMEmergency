//
//  HMHelperListVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/17.
//

import UIKit

class HMHelperListVC: UIViewController {
    
    var messages: [String] = ["我在天津理工大学主校区东门被困，我的联系方式为130XXXXX，需要帮助！","天津理工大学主校区东门发生洪水灾害！，我的联系方式为130XXXXX，需要帮助！"]

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionview = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = UIColor.clear
        collectionview.register(cellType: HMHomeMessageCell.self)
        return collectionview
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = shareColor.greenWrite
        self.title = "求助中心"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        let item = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(rightTopButtonMethod))
        item.tintColor = UIColor.red
        navigationItem.setRightBarButton(item, animated: true)
    }
    
    
    func setUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    @objc func rightTopButtonMethod() {
        let visitingServiceVC = HMVisitingServiceVC()
        visitingServiceVC.delegate = self
        self.navigationController?.pushViewController(visitingServiceVC, animated: true)
    }

}


extension HMHelperListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeMessageCell.self)
        cell.load(message: self.messages[indexPath.row])
        return cell
    }
    
    // flowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth-20, height: 200)
    }
    
    
}

extension HMHelperListVC: HMVisitingServiceVCDelegate {
    func pushMessage(message: String) {
        self.messages.insert(message, at: 0)
        self.collectionView.reloadData()
        self.collectionView.setNeedsLayout()
    }
}
