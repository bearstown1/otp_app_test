//
//  OtpQrScanViewController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/20.
//

import UIKit
import CryptoKit
import CoreData

class OtpQrScanViewController: UIViewController {

    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isBack = true
    
    @IBOutlet weak var readerView: QrReaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.readerView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.readerView.start()
    }
    
}

enum ReaderStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol QrReaderViewDelegate: AnyObject {
    func readerComplete(status: ReaderStatus)
}

extension OtpQrScanViewController: QrReaderViewDelegate {

    func readerComplete(status: ReaderStatus) {
        switch status {
        case .success(let encodeString):
            
            if let encodeString {
                let encodeData = Data(base64Encoded: encodeString)
                let base64DecString = String(data: encodeData!, encoding: .utf8)
                
                guard let base64DecodeData = base64DecString?.data(using: .utf8) else {
                    return
                }
                
                if let otpInfo = try? JSONDecoder().decode(OtpInfo.self, from: base64DecodeData) {
                    saveOtpUser(otpInfo: otpInfo)
                }
                
            }
            
        case .fail:
            print("실패")
        case .stop( _):
            print("멈춤")
        }
            
    }
    
    func saveOtpUser(otpInfo: OtpInfo) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "UserList", in: context) else {
            return
        }

        guard let managedObejct = NSManagedObject(entity: entityDescription, insertInto: context) as? UserList else {
            return
        }
        
        managedObejct.user_id = otpInfo.userId
        managedObejct.pinNumber = otpInfo.otpPin
        managedObejct.company = otpInfo.companyName
        managedObejct.selectYN = false
               
        appDelegate.saveContext()
        
        self.tabBarController?.selectedIndex = 1
        
    }
    
}
