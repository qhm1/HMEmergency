//
//  HMHealthCardVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/16.
//

import UIKit

class HMHealthCardVC: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "个人健康卡"
        self.view.backgroundColor = shareColor.greenWrite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        
    }

}
