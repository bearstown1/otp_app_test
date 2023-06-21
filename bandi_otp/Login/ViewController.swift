//
//  ViewController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/07.
//

import UIKit
import CoreData
import CryptoKit

class ViewController: UIViewController {
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var passwordEntity = [PassWord]()

    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        self.title = "로그인"
         self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    @IBAction func initPassword(_ sender: Any) {
        let alert = UIAlertController(title: "초기화", message: "모든 데이터가 삭제됩니다.\n 삭제 하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            self.context.delete(self.passwordEntity[0])
            self.appDelegate.saveContext()
            
            self.moveToInitPasswordView()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: false)
    }
    
    func moveToInitPasswordView() {
        let storyBoard = UIStoryboard(name: "NewPassWord", bundle: nil)

        let newPasswordVC = storyBoard.instantiateViewController(withIdentifier: "NewPassWordController") as! NewPassWordController
        
        newPasswordVC.completionSave = {
            self.fetchData()
        }
        
        
        self.navigationController?.pushViewController(newPasswordVC, animated: true)
        
        
    }
    
    
    @IBAction func checkPassword(_ sender: Any) {
        var password  = passwordField.text ?? ""
        let encodedPassword  = passwordEntity[0].password ?? ""
        password = encodePassword(password: password)
        
        if password == encodedPassword {
            let storyBoard = UIStoryboard(name: "Otp", bundle: nil)

            let otpVC = storyBoard.instantiateViewController(withIdentifier: "OtpTabbarController") as! OtpTabbarController
            
            // self.present(otpVC, animated: true)
            self.navigationController?.pushViewController(otpVC, animated: true)
            
            // self.tabBarController?.present(otpVC, animated: true)
            print("패스워드 일치")
        } else {
            print("패스워드가 일치하지 않습니다")
        }
        
    }
    
    func encodePassword(password: String) -> String{
        guard let data = password.data(using: .utf8) else {
            return ""
        }
        let bytes = SHA512.hash(data: data)
        let encodedPassword = Data(bytes).base64EncodedString()
        
        return encodedPassword
    }
    
    func fetchData() {
        let fetchRequest = PassWord.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            passwordEntity = try context.fetch(fetchRequest)
            
            if passwordEntity.count < 1 {
                moveToInitPasswordView()
            }
        } catch {
            print(error)
        }
    }
    
}

