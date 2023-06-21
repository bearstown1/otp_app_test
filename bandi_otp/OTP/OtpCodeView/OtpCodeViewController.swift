//
//  OtpCodeViewController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/16.
//

import UIKit

class OtpCodeViewController: UIViewController {
    var timer: Timer?
    
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var remainingTime: UILabel!
    
    @IBOutlet weak var otpCodeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.remainingTime.font =  UIFont.boldSystemFont(ofSize: 35)
        
        self.remainingTime.text = getCurrentSecond()
        let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), lineWidth: 15, rounded: false)
        
        progressView.progressColor = .red

        progressView.trackColor = .orange
        
        progressView.frame.origin = timerView.bounds.origin
        progressView.center = timerView.convert(timerView.center, from: progressView)
        self.timerView.addSubview(progressView)

        self.otpCodeLabel.text = OtpGenerator.generateOtpCode()
        timer = Timer(timeInterval: 1, repeats: true, block: { _ in
            let currentSecond = self.getCurrentSecond()
            self.remainingTime.text = String(60 - (Int(currentSecond) ?? 0))
            progressView.progress = Double(1) / Double(60) * (Double(currentSecond) ?? 0)
            
            if Int(currentSecond) ?? 0 <= 1 {
                self.otpCodeLabel.text = OtpGenerator.generateOtpCode()
            }
        })

        RunLoop.current.add(timer!, forMode: .common)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.otpCodeLabel.text = OtpGenerator.generateOtpCode()
    }
    
    func getCurrentSecond() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        let currentSecond = formatter.string(from: Date())
        
        return currentSecond
    }

}
