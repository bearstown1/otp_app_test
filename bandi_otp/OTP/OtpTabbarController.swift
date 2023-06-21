//
//  OtpTabbarController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/09.
//

import UIKit

class OtpTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationItem.title = "OTP"
        self.navigationItem.hidesBackButton = true
        
    }

}


extension OtpTabbarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.navigationItem.rightBarButtonItem?.isHidden = true

        if item.title == "OTP" {
            
            self.title = "OTP"
        } else if item.title == "사용자 목록" {
            
            self.title = "OTP 목록"
            self.navigationItem.rightBarButtonItem?.isHidden = false
        } else if item.title == "QR코드" {
            
            self.title = "QR스캔"
        } else if item.title == "설정" {
            
            self.title = "설정"
        }
        
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
}
