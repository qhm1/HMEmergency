//
//  HMApplyManager.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/14.
//

import AEAlertView
import Alamofire
import UIKit

class HMApplyManager: NSObject {
    var isAppling: Bool = false
    lazy var locationManager = AMapLocationManager()

    override init() {
        super.init()
        configLocationManager()
    }

    func configLocationManager() {
        let defaultLocationTimeout = 6
        let defaultReGeocodeTimeout = 3
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        locationManager.pausesLocationUpdatesAutomatically = false

        // locationManager.allowsBackgroundLocationUpdates = true

        locationManager.locationTimeout = defaultLocationTimeout

        locationManager.reGeocodeTimeout = defaultReGeocodeTimeout
    }

    func applySOS(situationId: Int, message: String) {
        locationManager.requestLocation(withReGeocode: true) { [weak self] (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            if let error = error {
                let error = error as NSError

                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    // 定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                } else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    // 逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                } else {
                    // 没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }

            var locationString: String!
            // 设置location
            if let location = location {
                if let regeocode = regeocode {
                    var citystring = ""
                    var adcodeStrin = ""
                    if (regeocode.citycode != nil) {
                        citystring.append(regeocode.citycode)
                    }
                    if (regeocode.adcode != nil) {
                        adcodeStrin.append(regeocode.adcode)
                    }
                    
                    locationString = "\(regeocode.formattedAddress!) \n \(citystring )-\(adcodeStrin)-\(location.horizontalAccuracy)m"
//                    AEAlertView.show(title: "提示", actions: ["确定"], message: locationString, handler: nil)
                }
            }

            let path = host + "/user/sos/apply"
            let param = [
                "location": locationString,
                "message": message,
                "situationId": String(situationId),
            ]

            let headers: HTTPHeaders = [
                "Authorization": shareLoginManager.token!,
                "Accept": "application/json",
            ]
            AF.request(path,
                       method: .post,
                       parameters: param,
                       encoder: JSONParameterEncoder.default,
                       headers: headers,
                       interceptor: nil,
                       requestModifier: nil).responseJSON { response in
                switch response.result {
                case let .success(value):
                    if let JSON = value as? [String: Any] {
                        let code: String? = JSON["code"] as? String
                        let message: String? = JSON["message"] as? String
                        if code != "00000" {
                            AEAlertView.show(title: nil, actions: ["确定"], message: message, handler: nil)
                            return
                        } else {
                            AEAlertView.show(title: message, actions: ["确定"], message: locationString, handler: nil)
                        }
                        let data: [String: Any?]? = JSON["data"] as? [String: Any?]
                        debugPrint(code ?? String.self)
                        debugPrint(message ?? String.self)
                        debugPrint(data ?? [String: Any?].self)
//                        AEAlertView.show(title: "提示", actions: ["确定"], message: message, handler: nil)
                        
                    }
                case let .failure(error):
                    AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
                }
            } // request finish
        } // location finish
    } // func finish
    
    
    func cancel() {
        let path = host + "/user/sos/cancel"
        let headers: HTTPHeaders = [
            "Authorization": shareLoginManager.token!,
            "Accept": "application/json",
        ]
        
        AF.request(path,
                   method: .post,
                   parameters: ["":""],
                   encoder: JSONParameterEncoder.default,
                   headers: headers,
                   interceptor: nil,
                   requestModifier: nil).responseJSON { response in
            switch response.result {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    let code: String? = JSON["code"] as? String
                    let message: String? = JSON["message"] as? String
                    if code != "00000" {
                        AEAlertView.show(title: nil, actions: ["确定"], message: "已完成请求", handler: nil)
                        return
                    }
                    let data: [String: Any?]? = JSON["data"] as? [String: Any?]
                    debugPrint(code ?? String.self)
                    debugPrint(message ?? String.self)
                    debugPrint(data ?? [String: Any?].self)
                    AEAlertView.show(title: "提示", actions: ["确定"], message: "已完成请求", handler: nil)
                    
                }
            case let .failure(error):
                AEAlertView.show(title: "警告", actions: ["确定"], message: "网络错误\(error)", handler: nil)
            }
        } // request finish
        
        
    }// func finish
}

extension HMApplyManager: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
}

let shareApplyManager = HMApplyManager()
