//
//  HMVisitingServiceVC.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/4.
//

import UIKit
import NextGrowingTextView
import AEAlertView

protocol HMVisitingServiceVCDelegate {
    func pushMessage(message: String)
}

class HMVisitingServiceVC: UIViewController {

    let textView = NextGrowingTextView()
    lazy var locationManager = AMapLocationManager()
    var delegate: HMVisitingServiceVCDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = shareColor.greenWrite
        self.title = "上门服务"
        textView.placeholderAttributedText = NSAttributedString(
            string: "请输入",
            attributes: [
              .foregroundColor: UIColor.gray
            ]
          )
        textView.backgroundColor = UIColor.white
        textView.layer.cornerRadius = 12
        textView.minNumberOfLines = 7
        textView.maxNumberOfLines = 100
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(submitButtonDidtouch))
        self.navigationItem.setRightBarButton(item, animated: true)
        setUI()
        configLocationManager()
        getLocation()
    }
    
    func setUI() {
        view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        let testView = UIView()
        textView.backgroundColor = UIColor.red
        view.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(50)
        }
        
    }
    
    @objc func submitButtonDidtouch() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.pushMessage(message: self.textView.textView.text)
        self.textView.textView.text = ""
        AEAlertView.show(title: "提示", actions: ["确定"], message: "提交成功", handler: nil)
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
    
    func getLocation() {
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
                    self?.textView.textView.text = "我在：\(locationString!)，我的联系方式是：\(shareLoginManager.phone!)，我需要帮助！"
                }
            }
            
            
            
        } // location finish
    }

}


extension HMVisitingServiceVC: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
}
