//
//  HMLoginViewController.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/8/26.
//

import UIKit

class HMLoginViewController: HMLoginBaseViewController {
    let emailLabel = UILabel()
    let passworldLabel = UILabel()
    let emailText = UITextField()
    let passworldText = UITextField()
    let lineView = UIView()
    let lineView2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override init() {
        super.init()
        passworldText.isSecureTextEntry = true
        emailLabel.text = "手机号"
        passworldLabel.text = "密码"
        emailText.placeholder = "请填写手机"
        passworldText.placeholder = "请填写密码"
        lineView.backgroundColor = shareColor.textgray
        lineView.alpha = 0.2
        lineView2.backgroundColor = shareColor.textgray
        lineView2.alpha = 0.2
        
        
        view.addSubview(emailLabel)
        view.addSubview(passworldLabel)
        view.addSubview(emailText)
        view.addSubview(passworldText)
        view.addSubview(lineView)
        view.addSubview(lineView2)
        
        
        
        emailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftTopButton).offset(20)
            make.top.equalTo(avatarView.snp.bottom).offset(50)
        }
        emailText.snp.makeConstraints { (make) in
            make.centerY.equalTo(emailLabel)
            make.left.equalTo(emailLabel).offset(90)
            make.width.greaterThanOrEqualToSuperview().offset(-100)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        passworldLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailLabel.snp.bottom).offset(30)
            make.left.equalTo(emailLabel)
        }
        passworldText.snp.makeConstraints { (make) in
            make.left.equalTo(emailText)
            make.centerY.equalTo(passworldLabel)
            make.width.greaterThanOrEqualToSuperview().offset(-100)
        }
        lineView2.snp.makeConstraints { (make) in
            make.top.equalTo(passworldText.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        middleFirstButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(passworldText.snp.bottom).offset(50)
            make.width.equalToSuperview().offset(-60)
            make.height.equalTo(50)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftTopButtonMethod() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func middleFirstButtonMethod() {
        shareLoginManager.login(phone: emailText.text!, passworld: passworldText.text!)
    }
    
    override func middleSecondButtonMethod() {
        self.present(HMEnrollVC(), animated: true, completion: nil)
    }

}

