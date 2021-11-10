//
//  HomeDetalViewController.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/27.
//

import UIKit
import AEAlertView

class HomeDetalViewController: UIViewController {
    let titles = DetalEmergencyType
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(cellType: HMMineCell.self)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = shareColor.greenWrite
        title = "请选择"
//        let item = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(nextStep))
//        item.tintColor = UIColor.red
//        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
    
    @objc func nextStep() {
        print("next did touch")
        let doctorVC = HMSelectInfo(otherTeam: true, ambulance: true)
        //let testVC = HMTestMapViewController()
        self.navigationController?.pushViewController(doctorVC, animated: true)
    }
}

extension HomeDetalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath:\(indexPath)")
        switch titles[indexPath.row] {
        case "自然灾害":
            print("自然灾害")
            let vc = HMNaturalVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case "医疗救助":
            print("医疗救助")
            let doctorVC = HMSelectInfo(otherTeam: true, ambulance: true)
            self.navigationController?.pushViewController(doctorVC, animated: true)
        case "治安事件":
            print("治安事件")
            let vc = HMSecurityVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            AEAlertView.show(title: "提示", actions: ["确定"], message: "未知事件", handler: nil)
        }
    }
    
    //datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMMineCell.self)
        cell.load(model: HMFindCellModel(title: titles[indexPath.row], image: UIImage(named: titles[indexPath.row])))
        return cell
    }
    
    // flowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth-30, height: 200)
    }
}
