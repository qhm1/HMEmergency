//
//  HMHandbookVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/17.
//

import UIKit
import Alamofire
import AEAlertView

class HMHandbookVC: UIViewController {

    var titles: [titlesModel] = []
    
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
        self.title = "求生手册"
        self.view.backgroundColor = shareColor.greenWrite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
    }
    
    func setUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func loadData() {
        let path = host + "/category/getAll"
        let param = [
            "pageNum": 1,
            "pageSize": 10,
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": shareLoginManager.token!,
            "Accept": "application/json",
        ]
        AF.request(path,
                   method: .get,
                   parameters: param,
                   encoder: URLEncodedFormParameterEncoder(destination: .queryString),
                   headers: headers,
                   interceptor: nil,
                   requestModifier: nil).responseJSON { response in
            switch response.result {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    let code: String? = JSON["code"] as? String
                    if code != "00000" {
                        AEAlertView.show(title: nil, actions: ["确定"], message: "权限错误", handler: nil)
                        return
                    }
                    let message: String? = JSON["message"] as? String
                    let data: [String: Any?]? = JSON["data"] as? [String: Any?]
                    debugPrint(code ?? String.self)
                    debugPrint(message ?? String.self)
                    debugPrint(data ?? [String: Any?].self)
                    let list:[[String:Any]] = data?["categoryList"] as! [[String : Any]]
                    for item in list {
                        let model = titlesModel(name: item["name"] as! String, id: item["id"] as! Int64)
                        self.titles.append(model)
                    }
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
            }
        }
    }

}

extension HMHandbookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeMessageCell.self)
        cell.load(message: self.titles[indexPath.row].name)
        return cell
    }
    
    // flowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth-20, height: 200)
    }
    
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(HMHandBookDetalVC(id: titles[indexPath.row].id), animated: true)
    }
    
    
}
