//
//  HMEnrollVC.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/8/26.
//

import UIKit
import AEAlertView

class HMEnrollVC: HMLoginBaseViewController {
    //let NickCell = HMLoginViewCell(left: "昵称", right: "请填写昵称")
    let emailCell = HMLoginViewCell(left: "手机号", right: "请填写手机")
    let codeCell = HMLoginViewCell(left: "验证码", right: "请填写验证码")
    let passwordCell = HMLoginViewCell(left: "密码", right: "请填写密码")
    let allowButton = HMCircleButton()
    let allowLabel = UILabel()
    let allowLabel2 = UILabel()
    var isAllow:Bool {
        get {
            return allowButton.isSelected
        }
    }

    
    override init() {
        super.init()
        rightTopButton.isHidden = true
        codeCell.text.text = "1234"
        middleFirstButton.isHidden = true
        leftTopButton.setTitle("取消", for: .normal)
        middleSecondButton.setTitle("下一步", for: .normal)
        middleLabel.text = "手机注册"
        allowLabel.text = "以阅读并同意"
        allowLabel.textColor = UIColor.gray
        allowLabel2.text = "《软件许可及服务协议》"
        allowLabel2.textColor = UIColor.blue
        allowLabel.alpha = 0.5
        allowLabel2.alpha = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func middleSecondButtonMethod() {
        if isAllow {
            shareLoginManager.enroll(phone: emailCell.text.text!, passworld: passwordCell.text.text!, code: codeCell.text.text!)
        } else {
            AEAlertView.show(title: "提示", actions: ["确定"], message: "请同意用户协议", handler: nil)
        }
    }
    
    func setLayout() {
        //view.addSubview(NickCell)
        view.addSubview(emailCell)
        view.addSubview(codeCell)
        view.addSubview(passwordCell)
        view.addSubview(allowButton)
        view.addSubview(allowLabel)
        view.addSubview(allowLabel2)

//        NickCell.snp.makeConstraints { (make) in
//            make.top.equalTo(avatarView.snp.bottom).offset(50)
//            make.centerX.equalToSuperview()
//        }
        emailCell.snp.makeConstraints { (make) in
            //make.top.equalTo(NickCell.snp.bottom)
            make.top.equalTo(avatarView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        codeCell.snp.makeConstraints { (make) in
            make.top.equalTo(emailCell.snp.bottom)
            make.centerX.equalToSuperview()
        }
        passwordCell.snp.makeConstraints { (make) in
            make.top.equalTo(codeCell.snp.bottom)
            make.centerX.equalToSuperview()
        }
        allowButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-350)
            make.top.equalTo(passwordCell.snp.bottom).offset(40)
        }
        allowLabel.snp.makeConstraints { (make) in
            make.left.equalTo(allowButton.snp.right).offset(2)
            make.centerY.equalTo(allowButton)
        }
        allowLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(allowLabel.snp.right)
            make.centerY.equalTo(allowLabel)
        }
        middleSecondButton.snp.remakeConstraints { (make) in
            make.top.equalTo(allowButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-60)
            make.height.equalTo(50)
        }
        
    }
    override func leftTopButtonMethod() {
        self.dismiss(animated: true, completion: nil)
    }
}
