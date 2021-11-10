//
//  HMMineViewController.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/27.
//

import UIKit
import AEAlertView

class HMMineViewController: UIViewController {
    var CardsData: [HMFindCellModel] = [HMFindCellModel(title: "请登录", image: UIImage(named: "头像")),HMFindCellModel(title: "个人健康卡", image: UIImage(named: "头像"))]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(cellType: HMMineCell.self)
        collectionView.register(cellType: HMwebCell.self)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "我的"
        view.backgroundColor = shareColor.greenWrite
        collectionView.delegate = self
        collectionView.dataSource = self
        
        shareLoginManager.loginDismiss = {
            print("loginDismiss")
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.collectionView.reloadData()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage(named: "我的")
        setUI()
    }
    
    func setUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
}

extension HMMineViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CardsData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if (indexPath.row == 2) {
//            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMwebCell.self)
//            cell.load(html: Htmltest)
//            return cell
//        }
        var model = CardsData[indexPath.row]
        if indexPath.row == 0 {
            let test = shareLoginManager.phone
            model.title = shareLoginManager.phone
        }
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMMineCell.self)
        cell.load(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth-40, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.present(HMLoginViewController(), animated: true, completion: nil)
            self.navigationController?.navigationBar.isHidden = false
        case 1:
            AEAlertView.show(title: "提示(开发中)", actions: ["确定"], message: "个人健康卡", handler: nil)
//            AEAlertView.show(title: nil, actions: ["确定"], message: "\(shareLoginManager.isLogin)", handler: nil)
//            self.navigationController?.pushViewController(HMVideoCallVC(), animated: true)
        default:
            print("default")
        }
    }
}
