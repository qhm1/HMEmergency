//
//  HMLoginManager.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/6.
//

import UIKit
import Alamofire
import AEAlertView

let host = ""

class HMLoginManager: NSObject {
    var isLogin: Bool? {
        get {
            return userDefault.value(forKey: "login") as? Bool ?? false
        }
        set {
            userDefault.setValue(newValue, forKey: "login")
        }
    }
    var token: String? {
        get {
            if self.isLogin == true {
                return userDefault.value(forKey: "token") as? String ?? ""
            } else {
                print("未登录获取token")
                return ""
            }
            
        }
        set {
            userDefault.setValue(newValue, forKey: "token")
        }
    }
    var phone: String? {
        get {
            if isLogin == true {
                return userDefault.value(forKey: "phone") as? String ?? "未登陆"
            } else {
                return "未登陆"
            }
        }
        set {
            userDefault.setValue(newValue, forKey: "phone")
        }
    }
    
    var userId: Int64? {
        get {
            if isLogin == true {
                return userDefault.value(forKey: "userId") as? Int64 ?? 0
            } else {
                return 0
            }
        }
        set {
            userDefault.setValue(newValue, forKey: "userId")
        }
    }
    let userDefault = UserDefaults.standard
    var loginDismiss:(()->())?
    
    override init() {
        super.init()
    }
    
    func enroll(phone: String, passworld: String, code: String) {
        let para: [String: String] = [
            "phone" : phone,
            "password" : passworld,
            "verificationCode" : code
        ]
        AF.request(host + "/user/signIn", method: .post, parameters: para, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in
            switch response.result {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    let code: String? = JSON["code"] as? String
                    let message: String? = JSON["message"] as? String
                    let data: [String: Any?]? = JSON["data"] as? [String: Any?]
                    debugPrint(code ?? String.self)
                    debugPrint(message ?? String.self)
                    debugPrint(data ?? [String: Any?].self)
                    if code != "00000" {
                        AEAlertView.show(title: "提示", actions: ["确定"], message: message, handler: nil)
                        //userDafault.set(false, forKey: "isLogin")
                        // 封装好了一个方法
                        self.isLogin = false
                    } else {
                        AEAlertView.show(title: "提示", actions: ["确定"], message: "登陆成功"+((data?["token"] as? String)!), handler: nil)
                        //保存数据
                        //userDafault.set(true, forKey: "isLogin")
                        //封装好了一个方法
                        let token1: String = data!["token"] as! String
                        let userId1:Int64 = data!["userId"] as! Int64
                        self.isLogin = true
                        self.token = token1
                        self.phone = phone
                        self.userId = userId1
                    }
                }
            case let .failure(error):
                AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
            }
        }
    }
    
    func login(phone: String, passworld: String){
        let para: [String: String] = [
            "phone" : phone,
            "password" : passworld
        ]
        
        AF.request(host + "/user/login", method: .post, parameters: para, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in
            switch response.result {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    let code: String? = JSON["code"] as? String
                    let message: String? = JSON["message"] as? String
                    let data: [String: Any?]? = JSON["data"] as? [String: Any?]
                    debugPrint(code ?? String.self)
                    debugPrint(message ?? String.self)
                    debugPrint(data ?? [String: Any?].self)
                    if code != "00000" {
                        AEAlertView.show(title: "提示", actions: ["确定"], message: message, handler: nil)
                        //userDafault.set(false, forKey: "isLogin")
                        // 封装好了一个方法
                        self.isLogin = false
                    } else {
                        AEAlertView.show(title: "提示", actions: ["确定"], message: "登陆成功\(data?["token"])", handler: nil)
                        //保存数据
                        //userDafault.set(true, forKey: "isLogin")
                        //封装好了一个方法
                        let token1: String = data!["token"] as! String
                        self.isLogin = true
                        self.token = token1
                        self.phone = phone
                        self.loginDismiss?()
                        let userId1:Int64 = data!["userId"] as! Int64
                        self.userId = userId1
                    }
                }
            case let .failure(error):
                AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
            }
        }
      
        
    }
}

let shareLoginManager = HMLoginManager()
