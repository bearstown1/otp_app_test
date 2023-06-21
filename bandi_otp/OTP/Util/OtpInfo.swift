//
//  OtpInfo.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/20.
//

import Foundation

struct OtpInfo: Codable {
    var userId: String
    var otpPin: String
    var companyName: String
    var createdTime: Int
    var duration: Int
}
