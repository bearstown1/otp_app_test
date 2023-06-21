//
//  NewPassWordController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/07.
//

import UIKit
import CoreData
import CryptoKit

class NewPassWordController: UIViewController {
    
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var newPasswordConfirm: UITextField!
    
    
    @IBOutlet weak var validatePasswordLabel: UILabel!
    
    
    @IBOutlet weak var validatePasswordConfirmLabel: UILabel!
    
    
    var passwordEntity : PassWord?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    var completionSave: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPassword.delegate = self
        newPasswordConfirm.delegate = self
        
        newPassword.layer.borderWidth = 1.0
        newPasswordConfirm.layer.borderWidth = 1.0
        
        self.navigationItem.title = "새로운 비밀번호"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.hidesBackButton = true
    }


    @IBAction func checkPassword(_ sender: Any) {
        let password = newPassword.text ?? ""
        let passwordconfirm = newPasswordConfirm.text ?? ""
        if password == "" {
            showValidationMessage(textField: self.newPassword, label: self.validatePasswordLabel)
            
            return
        }
        
        if (passwordconfirm == "") {
            showValidationMessage(textField: self.newPasswordConfirm, label: self.validatePasswordLabel)
            
            return
        }
        
        if (password != passwordconfirm) {
            let alert = UIAlertController(title: "오류", message: "비밀번호가 맞지않습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            }
            alert.addAction(okAction)
            present(alert, animated: false)
            
            return
        }
        
        // 로직
        savePassword(password: password)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func savePassword(password: String) {
        guard let data = password.data(using: .utf8) else { return }
        let bytes = SHA512.hash(data: data)
        let encodedPassword = Data(bytes).base64EncodedString()
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "PassWord", in: context) else {
            return
        }
        
        guard let managedObejct = NSManagedObject(entity: entityDescription, insertInto: context) as? PassWord else {
            return
        }
        
        managedObejct.password = encodedPassword
        
        appDelegate.saveContext()
        
        completionSave?()
    }
    
    
}

extension NewPassWordController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let input = NSString(string: textField.text ?? "")
        let output = input.replacingCharacters(in: range, with: string)
        
        if textField == newPassword {
            if output.count < 1 {
                showValidationMessage(textField: textField, label: self.validatePasswordLabel)
            } else {
                hideValidationMessage(textField: textField, label: self.validatePasswordLabel)
            }
        } else {
            if output.count < 1 {
                showValidationMessage(textField: textField, label: self.validatePasswordConfirmLabel)
            } else {
                hideValidationMessage(textField: textField, label: self.validatePasswordConfirmLabel)
            }
        }
        
        return true
    }
    
    func showValidationMessage(textField: UITextField, label: UILabel) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.red.cgColor
        
        if textField == newPassword {
            label.text = "새로운 비밀번호를 입력하세요!"
        } else {
            label.text = "새로운 비밀번호 확인을 입력하세요!"
        }
    }
    
    func hideValidationMessage(textField: UITextField, label: UILabel) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        label.text = ""
    }
    
    
}
