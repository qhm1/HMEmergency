//
//  HMHomeViewController.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/27.
//

import UIKit
import SnapKit
import AEAlertView

class HMHomeViewController: UIViewController {
    
    private let sosButton = UIButton()
    var floatBtn: UIView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "首页"
        view.backgroundColor = shareColor.greenWrite
        sosButton.setImage(UIImage(named: "紧急按钮"), for: .normal)
        //sosButton.backgroundColor = UIColor.red
        sosButton.addTarget(self, action: #selector(sosButtonDidTouch), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage(named: "首页")
        //addDragFloatBtn()
        setUI()
    }
    
    func setUI() {
        view.addSubview(sosButton)
        sosButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func sosButtonDidTouch() {
        self.navigationController?.pushViewController(HomeDetalViewController(), animated: true)
        //self.navigationController?.pushViewController(HMDoctorGuideVC(), animated: true)
    }
    
    func addDragFloatBtn() {
            // 创建按钮
            let btn = UIButton(frame: CGRect(x: 10, y: 200, width: 80,             height: 80))
            btn.backgroundColor = UIColor.orange
            btn.layer.cornerRadius = 20.0
            self.view .addSubview(btn)
            btn.addTarget(self, action: #selector(floatBtnAction(sender:)),         for: .touchUpInside)
            self.floatBtn = btn

            // 创建手势
            let panGesture = UIPanGestureRecognizer(target: self, action:         #selector(dragAction(gesture:)))
            btn .addGestureRecognizer(panGesture)
        }

        @objc func dragAction(gesture: UIPanGestureRecognizer) {
            // 移动状态
            let moveState = gesture.state
            switch moveState {
                case .began:
                    break
                case .changed:
                    // floatBtn 获取移动轨迹
                    let point = gesture.translation(in: self.view)
                    self.floatBtn!.center = CGPoint(x: self.floatBtn!.center.x                 + point.x, y: self.floatBtn!.center.y + point.y)
                    break
                case .ended:
                    // floatBtn 移动结束吸边
                    let point = gesture.translation(in: self.view)
                    var newPoint = CGPoint(x: self.floatBtn!.center.x +                     point.x, y: self.floatBtn!.center.y + point.y)
                    if newPoint.x < self.view.bounds.width / 2.0 {
                        newPoint.x = 40.0
                    } else {
                        newPoint.x = self.view.bounds.width - 40.0
                    }
                    if newPoint.y <= 40.0 {
                        newPoint.y = 40.0
                    } else if newPoint.y >= self.view.bounds.height - 40.0 {
                        newPoint.y = self.view.bounds.height - 40.0
                    }
                    // 0.5秒 吸边动画
                    UIView.animate(withDuration: 0.5) {
                        self.floatBtn!.center = newPoint
                    }
                    break
                default:
                    break
            }
            // 重置 panGesture
            gesture.setTranslation(.zero, in: self.view)
        }

        @objc func floatBtnAction(sender: UIButton) {
            print("floatBtnAction")
        }

    
}
