//
//  HMDoctorGuideVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/2.
//

import UIKit
import Alamofire
import AEAlertView
import Starscream
import TXLiteAVSDK_TRTC

class HMSelectInfo: UIViewController {
    
    var isApplying: Bool = false
    var situationTitles : [titlesModel] = []
    var pushMessage: [String] = []
    var receiveMessage : [titlesModel] = []
    var selectSituation: titlesModel?
    var firstRecieve = true
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionview = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = shareColor.greenWrite
        
        collectionview.register(cellType: HMDoctorGuideCell.self)
        collectionview.register(cellType: HMHomeMapCell.self)
        collectionview.register(cellType: HMHomeSymptomCell.self)
        collectionview.register(cellType: HMPatientInfoCell.self)
        collectionview.register(cellType: HMVideoCallCell.self)
        collectionview.register(cellType: HMHomeMessageCell.self)
        return collectionview
    }()
    
    lazy var socket: WebSocket = {
        print("begin websocket")
        let token: String = shareLoginManager.token!
        var request = URLRequest(url: URL(string: "\(host)/sos/webSocket/\(token)")!)
        print("\(host)/sos/webSocket/\(token)")
        request.timeoutInterval = 5
        var socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        return socket
    }()
    
    let bottomTextView = HMBottomTextView()
    
    init(otherTeam:Bool, ambulance: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.title = "快速填写信息"
        _ = self.socket
        self.bottomTextView.btn.addTarget(self, action: #selector(sentBtnDidTouch), for: .touchUpInside)
    }
    
    deinit {
        if self.isApplying {
            shareApplyManager.cancel()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TRTCCloud.destroySharedIntance() // 解决内存泄漏
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexColor(hex: "f5f6f8")
        let item = UIBarButtonItem(title: "结束", style: .plain, target: self, action: #selector(nextStep))
        item.tintColor = UIColor.red
        self.navigationItem.setRightBarButton(item, animated: true)
        loadData()
        setUI()
    }
    
    func setUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.bottom.equalToSuperview()
        }
        view.addSubview(bottomTextView)
        bottomTextView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @objc func nextStep() {
        print("next")
        shareApplyManager.cancel()
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        let path = host + "/situation/getByCategory"
                let param = [
                    "categoryId": 2,
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
                            let list:[[String:Any]] = data?["situationList"] as! [[String : Any]]
                            for item in list {
                                let model = titlesModel(name: item["name"] as! String, id: item["id"] as! Int64)
                                self.situationTitles.append(model)
                            }
                            self.collectionView.reloadSections(IndexSet(integer: 2))
                            print("")
                        }
                    case let .failure(error):
                        AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
                    }// switch finish
            }//request finish
    } // func finish
    
    func loadMethod(id:Int64) {
        let path = host + "/method/getBySituation"
        let param = [
            "situationId": id,
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
                    let message: String? = JSON["message"] as? String
                    let data: [String: Any?]? = JSON["data"] as? [String: Any?]
                    debugPrint(code ?? String.self)
                    debugPrint(message ?? String.self)
                    debugPrint(data ?? [String: Any?].self)
                    let list:[[String:Any]] = data?["methodList"] as! [[String : Any]]
                    for item in list {
                        let name: String = item["name"]as! String
                        let id:Int64 = item["id"] as! Int64
                        let description: String = item["description"] as! String
                        let itemMessage = name+description
                        let model = titlesModel(name: itemMessage, id: id)
                        self.receiveMessage.insert(model, at: 0)
                        
                    }
                    self.isApplying = true
                    self.receiveMessage.insert(titlesModel(name: "后台已收到请求✅", id: -1), at: 0)
                    self.collectionView.reloadSections(IndexSet(integer: 3)) // 刷新消息列表
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 2), at: .centeredVertically, animated: true)
                    print("")
                }
            case let .failure(error):
                AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
            } //switch
        } // request
        
    } // func finish
    
    @objc func sentBtnDidTouch() {
        print("sentBtnDidTouch")
        let messageString = """
            {
                "msg_type": "4",
                "content": {
                    "text": "\(bottomTextView.textView.textView.text!)",
                    "receiver": ""
                }
            }
            """
        socket.write(string: messageString)
        self.receiveMessage.insert(titlesModel(name: "\(shareLoginManager.phone!)说:\(bottomTextView.textView.textView.text!)", id: -1), at: 0)
        collectionView.reloadSections(IndexSet(integer: 2))
        bottomTextView.textView.textView.text = ""
        bottomTextView.textView.endEditing(true)
    }
    
    func socketSentMessage(message: String) {
        let messageString = """
            {
                "msg_type": "4",
                "content": {
                    "text": "\(message)",
                    "receiver": ""
                }
            }
            """
        socket.write(string: messageString)
        self.receiveMessage.insert(titlesModel(name: "\(shareLoginManager.phone!)说:\(bottomTextView.textView.textView.text!)", id: -1), at: 0)
        collectionView.reloadSections(IndexSet(integer: 2))
        bottomTextView.textView.textView.text = ""
        bottomTextView.textView.endEditing(true)
    }
    

} //class finish

extension HMSelectInfo: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: //map or videoCall
            return 1
        case 1: // user info
            if isApplying {
                return 0
            } else {
                return 1
            }
        case 2: // situation info
            if isApplying {
                return 0
            } else {
                return 1
            }
        case 3:
            return self.receiveMessage.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: UICollectionViewCell
//        switch indexPath.row {
//        case 0:
//            cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeMapCell.self)
//            if let c = cell as? HMHomeMapCell {
//                c.load()
//            }
//        case 1:
//            cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeSymptomCell.self)
//            if let c = cell as? HMHomeSymptomCell {
//                c.collectionView = self.collectionView
//                c.load()
//            }
//        case 2:
//            cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMPatientInfoCell.self)
//            if let c = cell as? HMPatientInfoCell {
//                c.load()
//            }
//        default:
//            cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMDoctorGuideCell.self)
//            cell.backgroundColor = UIColor.white
//            cell.layer.commonStyle()
//        }
//        return cell
        
        switch indexPath.section {
        case 0: //map or videoCall
            if self.isApplying == true {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMVideoCallCell.self)
                cell.load()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeMapCell.self)
                cell.load()
                return cell
            }
        case 1: // user info
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMPatientInfoCell.self)
            cell.load()
            cell.superVC = self
            return cell
        case 2:// situation info
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeSymptomCell.self)
            cell.load(titles: self.situationTitles)
            cell.collectionView = self.collectionView
            cell.delegate = self
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeMessageCell.self)
            cell.load(message: self.receiveMessage[indexPath.row].name)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    //flowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth-20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
    }
}


extension HMSelectInfo: HMHomeSymptomCellDelegate {
    func selectSituation(situation: titlesModel) {
        self.selectSituation = situation
        self.isApplying = true
        self.collectionView.reloadData()
        loadMethod(id: situation.id)
        var pushStr: String = ""
        pushStr.append(situation.name)
        for item in self.pushMessage {
            pushStr.append(item)
        }
        shareApplyManager.applySOS(situationId: Int(self.selectSituation!.id), message: pushStr)
    }
}


extension HMSelectInfo: WebSocketDelegate {
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
            let recivedJSON = stringValueDic(string)
            let content:[String:Any] = recivedJSON!["content"] as! [String : Any]
            let text: String = content["text"] as! String
//            if firstRecieve == true{
//                firstRecieve = false
//                socketSentMessage(message: "需要救助！我的联系方式为：\(shareLoginManager.phone!)\(pushMessage)")
//            }
            if text == "#finish#" {
                shareApplyManager.cancel()
                self.navigationController?.popViewController(animated: true)
            }
            self.receiveMessage.insert(titlesModel(name: text, id: -1), at: 0)
            self.collectionView.reloadSections(IndexSet(integer: 3))
        
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
    
    func stringValueDic(_ str: String) -> [String : Any]?{
            let data = str.data(using: String.Encoding.utf8)
            if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
                return dict
            }
            return nil
    }
}
