//
//  HMBottomTextView.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/16.
//

import UIKit
import NextGrowingTextView

class HMBottomTextView: UIView {

    let textView = NextGrowingTextView()
    let btn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = shareColor.textgray
        textView.placeholderAttributedText = NSAttributedString(
            string: "请输入",
            attributes: [
              .foregroundColor: UIColor.gray
            ]
          )
        textView.backgroundColor = UIColor.white
        textView.layer.cornerRadius = 6
        textView.minNumberOfLines = 2
        textView.maxNumberOfLines = 7
        btn.setTitle("发送", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.white, for: .highlighted)
        setUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.addSubview(textView)
        self.addSubview(btn)
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(-10)
//            make.right.equalToSuperview().offset(-10)
        }
        
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(textView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
      if let userInfo = (sender as NSNotification).userInfo {
        if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
          //key point 0,
          //self.inputContainerViewBottom.constant = 0
            self.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
          //textViewBottomConstraint.constant = keyboardHeight
//          UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
        }
      }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
      if let userInfo = (sender as NSNotification).userInfo {
        if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
//          self.inputContainerViewBottom.constant = keyboardHeight
            self.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-keyboardHeight)
            }
            self.layoutIfNeeded()
//          UIView.animate(withDuration: 0.25, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//          })
        }
      }
    }
    
}
