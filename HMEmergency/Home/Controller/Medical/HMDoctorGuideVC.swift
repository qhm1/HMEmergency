//
//  HMDoctorGuideVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/2.
//

import UIKit
import Starscream

class HMDoctorGuideVC: UIViewController {
    
    var cardList:[Any]?
    var titles: [String] = ["实时定位中","症状","患者","救护车正在赶来","语音指导开始",]
    var cardsName: [String] = ["image-1","image-2"]
    var socket: WebSocket?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 20
        let collectionview = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = UIColor.clear
        collectionview.register(cellType: HMDGMiniCell.self)
        collectionview.register(cellType: HMDGImageCell.self)
        return collectionview
    }()
    
    private let testView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = shareColor.greenWrite
        self.title = "医生指导开始"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "结束", style: .plain, target: self, action: #selector(nextStep))
        item.tintColor = UIColor.red
        self.navigationItem.setRightBarButton(item, animated: true)
        setUI()
        receiveMessage()
    }
    
    func setUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    @objc func nextStep() {
        print("nextStep")
    }
    
    
    
    func receiveMessage() {
        print("begin websocket")
        let token: String = shareLoginManager.token!
        var request = URLRequest(url: URL(string: "\(host)/sos/webSocket/\(token)")!)
        print("\(host)/sos/webSocket/\(token)")
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket!.delegate = self
        socket!.connect()
    }
}

extension HMDoctorGuideVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count+(cardsName.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < titles.count {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMDGMiniCell.self)
            cell.load(title: titles[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMDGImageCell.self)
            let index1 = indexPath.row - title!.count + 1
            cell.load(imageName: cardsName[index1])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < titles.count {
            return CGSize(width: HMwidth-20, height: 50)
        } else {
            return CGSize(width: HMwidth-20, height: 400)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect indexpath\(indexPath)")
    }
    
}


extension HMDoctorGuideVC: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            //isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            //isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            //self.titles.append("\(string)")
            //self.collectionView.reloadData()
            self.cardsName.append("\(string)")
            self.collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: titles.count+cardsName.count, section: 0), at: .centeredHorizontally, animated: true)
        
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            //isConnected = false
            print("")
        case .error(_):
            //isConnected = false
            //handleError(error)
            print("")
        }
    }
}

