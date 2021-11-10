//
//  AppDelegate.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/9/27.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AMapServices.shared().apiKey = "" //地图定位
        IQKeyboardManager.shared.enable = true //收起键盘
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.makeKeyAndVisible()
        
        let HMHomeVC = HMHomeViewController()
        let HMFindVC = HMHealthStationVC()
        let HMMineVC = HMMineViewController()
        
        let tabbarController = UITabBarController()
        tabbarController.delegate = self
        tabbarController.title = HMHomeVC.title
        tabbarController.setViewControllers([HMHomeVC,HMFindVC,HMMineVC], animated: true)
        let nav = UINavigationController(rootViewController: tabbarController)
        self.window?.rootViewController = nav
        
        // 判断登陆的逻辑
        if shareLoginManager.isLogin == false {
            nav.present(HMLoginViewController(), animated: true, completion: nil)
        }
        
        return true
    }
    
}


extension AppDelegate: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBarController.title = viewController.title
    }
    
}

