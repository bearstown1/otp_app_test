//
//  OtpGenerator.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/16.
//

import Foundation
import CoreData
import UIKit
import CryptoKit
import SwiftOTP

class OtpGenerator {
    
   static func generateOtpCode() -> String {
        let userEntity = self.getSelectUser()

        if let userEntity {
            let secretKey = generateKeyString(userId: userEntity.user_id ?? "", otpPin: userEntity.pinNumber ?? "")
            let otpCode = generateTimeBaseOtp(secretKey: secretKey, otpCodeDuaration: 60)

            return otpCode
        }

      return ""
  }

    private static func getSelectUser() -> UserList? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        var userList = [UserList]()


        let request : NSFetchRequest<UserList> = UserList.fetchRequest()
        let predicate = NSPredicate(format: "selectYN == %@", NSNumber(booleanLiteral: true))
        request.predicate = predicate


        do {
            userList = try context.fetch(request)
            if userList.count == 1 {

                return userList[0]
            }

            return nil
        } catch {

            print(error)
        }

        return nil
    }

    private static func generateKeyString(userId: String, otpPin: String) -> String {
        if userId == "" || otpPin == "" {
            return ""
        }
        let value = userId + otpPin

        guard let data = value.data(using: .utf8) else {
            return ""
        }

        let bytes = SHA256.hash(data: data)
        let secretKey = Data(bytes).base32EncodedString

        return secretKey
    }

    private static func generateTimeBaseOtp(secretKey: String, otpCodeDuaration: Int) -> String{
        guard let secretKeyData = base32DecodeToData(secretKey) else {
            return ""
        }

        let totp = TOTP(secret: secretKeyData, digits: 6, timeInterval: otpCodeDuaration, algorithm: .sha512)

        let otpString = totp?.generate(time: Date())
        print("test")
        return otpString ?? ""
    }

}
