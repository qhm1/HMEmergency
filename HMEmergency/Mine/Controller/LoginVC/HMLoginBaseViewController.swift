//
//  HMLoginViewController.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/8/24.
//

import UIKit

class HMLoginTopButton: UIButton {
    init(title: String?) {
        super.init(frame: CGRect.zero)
        self.setTitleColor(shareColor.MainColor, for: .normal)
        self.setTitleColor(UIColor.lightText, for: .highlighted)
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HMLoginBaseViewController: UIViewController {
    let leftTopButton = HMLoginTopButton(title: "游客模式")
    let rightTopButton = HMLoginTopButton(title: "忘记密码")
    let middleLabel = UILabel()
    let avatarView = UIImageView()
    
    let middleFirstButton = HMButton()
    let middleSecondButton = HMButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        setUI()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = shareColor.greenWrite
        middleLabel.font = UIFont.systemFont(ofSize: 28)
        middleLabel.text = "手机登陆"
        avatarView.image = UIImage(named: "默认头像")
        
        middleFirstButton.setTitle("登 陆", for: .normal)
        middleSecondButton.setTitle("注 册", for: .normal)

        middleFirstButton.setColor(normal: shareColor.MainColor, highlighted: UIColor.clear)
        middleSecondButton.setColor(normal: shareColor.SecondColor, highlighted: UIColor.clear)
        middleSecondButton.setTitleColor(shareColor.textBlack, for: .normal)
        middleSecondButton.setTitleColor(.clear, for: .highlighted)
        middleFirstButton.layer.cornerRadius = 7
        middleSecondButton.layer.cornerRadius = 7
        leftTopButton.addTarget(self, action: #selector(leftTopButtonMethod), for: .touchUpInside)
        middleSecondButton.addTarget(self, action: #selector(middleSecondButtonMethod), for: .touchUpInside)
        middleFirstButton.addTarget(self, action: #selector(middleFirstButtonMethod), for: .touchUpInside)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        
        view.addSubview(leftTopButton)
        view.addSubview(rightTopButton)
        view.addSubview(middleLabel)
        view.addSubview(avatarView)

        view.addSubview(middleFirstButton)
        view.addSubview(middleSecondButton)

        
        leftTopButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(23)
            make.top.equalToSuperview().offset(shareSafeArea.getTop() + 10)
        }
        rightTopButton.snp.makeConstraints { (make) in
            make.top.equalTo(leftTopButton)
            make.right.equalToSuperview().offset(-23)
        }
        middleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(leftTopButton.snp.bottom).offset(10)
        }
        avatarView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(middleLabel.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        middleFirstButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(50)
            make.width.equalToSuperview().offset(-60)
            make.height.equalTo(50)
        }
        middleSecondButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(middleFirstButton)
            make.top.equalTo(middleFirstButton.snp.bottom).offset(25)
            make.width.equalTo(middleFirstButton)
            make.height.equalTo(middleFirstButton)
        }
    }
    
    @objc func leftTopButtonMethod() {
    }
    
    @objc func middleFirstButtonMethod() {
        
    }
    
    @objc func middleSecondButtonMethod() {
        
    }
}
