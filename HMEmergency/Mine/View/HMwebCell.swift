//
//  HMwebCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/30.
//

import UIKit
import WebKit
import Reusable

class HMwebCell: UICollectionViewCell, Reusable{
    let webview = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        webview.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(html: String) {
        //webview.loadHTMLString(html, baseURL: nil)
        webview.load(URLRequest(url: URL(string: "")!))
        setUI()
    }
    
    func setUI() {
        self.contentView.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
