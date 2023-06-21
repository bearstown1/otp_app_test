//
//  OtpViewController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/09.
//

import UIKit

class OtpViewController: UIViewController {
    
    @IBOutlet weak var otpCodeView: UIView!
    
    @IBOutlet weak var otpCodeWarningView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.otpCodeView.alpha = 1
        self.otpCodeWarningView.alpha = 0
    }

}

