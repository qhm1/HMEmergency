//
//  HMSecurityVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/9.
//

import AEAlertView
import Alamofire
import UIKit
import Starscream



class HMNaturalVC: UIViewController {
    var titles:[titlesModel] = []
    var Highlight: [Bool] = Array(repeating: false, count: 100)
    var message: [titlesModel] = []
    var pushMessage = ""
    var floatBtn: UIView?
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
    
    var isApplying: Bool = false
    let bottomTextView = HMBottomTextView()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.isPagingEnabled = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(cellType: HMHomeMapCell.self)
        collectionView.register(cellType: HMSelectSituationButtonCell.self)
        collectionView.register(cellType: HMHomeMessageCell.self)
        collectionView.register(cellType: HMVideoCallCell.self)
        return collectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = shareColor.greenWrite
        title = "自然灾害"
        bottomTextView.btn.addTarget(self, action: #selector(sentBtnDidTouch), for: .touchUpInside)
        _ = self.socket
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        if self.titles.count == 0 {
            shareApplyManager.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setUI()
        let item = UIBarButtonItem(title: "结束", style: .plain, target: self, action: #selector(rightTopButtonMethod))
        item.tintColor = UIColor.red
        navigationItem.setRightBarButton(item, animated: true)
    }

    func setUI() {
        view.addSubview(collectionView)
        view.addSubview(bottomTextView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        bottomTextView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    @objc func rightTopButtonMethod() {
        shareApplyManager.cancel()
    }
    
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
        self.message.insert(titlesModel(name: "\(shareLoginManager.phone!)说:\(bottomTextView.textView.textView.text!)", id: -1), at: 0)
        collectionView.reloadSections(IndexSet(integer: 2))
        bottomTextView.textView.textView.text = ""
        bottomTextView.textView.endEditing(true)
    }

    func loadData() {
        let path = host + "/situation/getByCategory"
        let param = [
            "categoryId": 1,
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
                        self.titles.append(model)
                    }
                    self.collectionView.reloadSections(IndexSet(integer: 1))
                    print("")
                }
            case let .failure(error):
                AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
            }
        }
    }
    
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
                        //self.message.append(itemMessage)
                        self.message.insert(model, at: 0)
                    }
                    self.isApplying = true
                    self.message.insert(titlesModel(name: "后台已收到请求✅", id: -1), at: 0)
                    self.collectionView.reloadSections(IndexSet(integer: 2))
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 2), at: .centeredVertically, animated: true)
                    print("")
                }
            case let .failure(error):
                AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
            } //switch
        } // request
        
    } // func finish
    func applySOS() {
        shareApplyManager.applySOS(situationId: 1, message: pushMessage)
    }
    
//    func initReceiveMessage() {
//        print("begin websocket")
//        let token: String = shareLoginManager.token!
//        var request = URLRequest(url: URL(string: "\(host)/sos/webSocket/\(token)")!)
//        print("\(host)/sos/webSocket/\(token)")
//        request.timeoutInterval = 5
//        socket = WebSocket(request: request)
//        socket.delegate = self
//        socket.connect()
//    }
    
//    func presentVideoCellVC() {
//        let storyboard = UIStoryboard.init(name: "RTC", bundle: nil);
//        guard let rtcVC = storyboard.instantiateViewController(withIdentifier: "RTCViewController") as? RTCViewController else {
//            return
//        }
//        rtcVC.roomId = UInt32(shareLoginManager.userId!)
//        self.navigationController?.pushViewController(rtcVC, animated: true)
//    }
    
}


extension HMNaturalVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return titles.count
        } else {
            return message.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if (!self.isApplying) {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeMapCell.self)
                cell.load()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMVideoCallCell.self)
                cell.load()
                return cell
            }
            
        case 1:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMSelectSituationButtonCell.self)
            cell.load(title: titles[indexPath.row].name, highLight: Highlight[indexPath.row])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMHomeMessageCell.self)
            cell.load(message: message[indexPath.row].name)
            return cell
        default:
            print("default")
            return UICollectionViewCell()
        }
    }

    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { //situation method
            let cell = collectionView.cellForItem(at: indexPath)
            print("didHighlightItemAt")
            if Highlight[indexPath.row] == true {
                cell?.contentView.backgroundColor = shareColor.blueWrite
                Highlight[indexPath.row] = false
            } else {
                cell?.contentView.backgroundColor = shareColor.MainColor
                Highlight = Array(repeating: false, count: 100)
                pushMessage.append(titles[indexPath.row].name)
                loadMethod(id: titles[indexPath.row].id)
                Highlight[indexPath.row] = true
                collectionView.reloadSections(IndexSet(integer: 1))
                self.titles = []
                collectionView.reloadSections(IndexSet(integer: 1))
                applySOS()
            }
        } else if indexPath.section == 2 {
            
        }
        print("index: \(indexPath)")
    }

    // flowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 30, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: HMwidth - 20, height: 200)
        } else if indexPath.section == 1 {
            return CGSize(width: HMwidth / 2 - 20, height: HMwidth / 2 - 20)
        } else {
            return CGSize()
        }
    }
    
    
}


extension HMNaturalVC: WebSocketDelegate {
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
            if text == "#finish#" {
                shareApplyManager.cancel()
                self.navigationController?.popViewController(animated: true)
            }
            self.message.insert(titlesModel(name: text, id: -1), at: 0)
            self.collectionView.reloadSections(IndexSet(integer: 2))
        
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
