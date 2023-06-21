//
//  OtpUserAddViewController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/09.
//

import UIKit
import TextFieldEffects
import CoreData

class OtpUserAddViewController: UIViewController {
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: OtpUserAddViewControllerProtocol?

    let idTextField = AkiraTextField(frame: CGRect(x: 70, y: 200, width: 250, height: 50))
    let pinNumberTextField = AkiraTextField(frame: CGRect(x: 70, y: 270, width: 250, height: 50))
    let companyTextField = AkiraTextField(frame: CGRect(x: 70, y: 340, width: 250, height: 50))
    
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var alertText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        self.title = "OTP 정보 추가"
        self.view.addSubview(self.alertView)
        self.alertView.alpha = 0
        idTextField.delegate = self
        pinNumberTextField.delegate = self
        companyTextField.delegate = self

        setField()

        setKeyboardObserver()
        // Do any additional setup after loading the view.
    }
    

    func setField() {
        idTextField.placeholder = "아이디"
        idTextField.placeholderColor = .black
        
        pinNumberTextField.placeholder = "pin번호 (숫자만 입력가능)"
        pinNumberTextField.placeholderColor = .black
        pinNumberTextField.keyboardType = .numberPad
        
        companyTextField.placeholder = "회사명"
        companyTextField.placeholderColor = .black
                
        self.view.addSubview(idTextField)
        self.view.addSubview(pinNumberTextField)
        self.view.addSubview(companyTextField)
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    @IBAction func saveOtpUser(_ sender: Any) {
        if validateForm() {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "UserList", in: context) else {
                return
            }

            guard let managedObejct = NSManagedObject(entity: entityDescription, insertInto: context) as? UserList else {
                return
            }

            let userId = self.idTextField.text ?? ""
            let pincode = self.pinNumberTextField.text ?? ""
            let company = self.companyTextField.text ?? ""


            managedObejct.user_id = userId
            managedObejct.pinNumber = pincode
            managedObejct.company = company
            managedObejct.selectYN = false

            appDelegate.saveContext()

            delegate?.didFinishSave()
            
            self.navigationController?.popViewController(animated: true)
            
        }
        

    }
    
    func validateForm() -> Bool{
        let userId = self.idTextField.text ?? ""
        let pincode = self.pinNumberTextField.text ?? ""
        let company = self.companyTextField.text ?? ""
        
        if userId == "" {
            self.idTextField.becomeFirstResponder()
            self.alertText.text = "아이디를 입력하세요"
            animationAlertView()
            return false
        }
        
        if pincode == "" {
            self.pinNumberTextField.becomeFirstResponder()
            self.alertText.text = "pin번호를 입력하세요"
            animationAlertView()
            return false
        }
        
        if company == "" {
            self.companyTextField.becomeFirstResponder()
            self.alertText.text = "회사명을 입력하세요"
            animationAlertView()
            return false
        }
        
        return true
    }
    
    func animationAlertView() {
        UIView.animate(withDuration: 1, animations:{
            self.alertView.alpha = 1
        } )
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 1, animations:{
                self.alertView.alpha = 0
            } )
        }
    }
    

    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.alertView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
       if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
       
               self.alertView.transform = CGAffineTransform(translationX: 0, y: 0)
           
       }
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
}

extension OtpUserAddViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        
        return true
    }
    
}


protocol OtpUserAddViewControllerProtocol {
    func didFinishSave()
}

