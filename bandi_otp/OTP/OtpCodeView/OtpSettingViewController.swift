//
//  OtpSettingViewController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/20.
//

import UIKit

class OtpSettingViewController: UIViewController {
    
    private var cellModel = [CellModel]()
    
    @IBOutlet weak var settingTableView: UITableView! {
        didSet {
            settingTableView.register(UINib(nibName: "PasswordChangeCell", bundle: nil), forCellReuseIdentifier: "PasswordChangeCell")
            
            settingTableView.register(UINib(nibName: "DeviceAuthCell", bundle: nil), forCellReuseIdentifier: "DeviceAuthCell")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellModel = [.passwordChange, .deviceAuth]
        settingTableView.delegate = self
        settingTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}


extension OtpSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellModel.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellModel[indexPath.row] {
        case .passwordChange :
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordChangeCell", for: indexPath) as! PasswordChangeCell
            
            cell.accessoryType = .disclosureIndicator
            return cell
        case .deviceAuth:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceAuthCell", for: indexPath) as! DeviceAuthCell

            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if CellModel.passwordChange == self.cellModel[indexPath.row] {
            let storyBoard = UIStoryboard(name: "PasswordChange", bundle: nil)

            let changePwVC = storyBoard.instantiateViewController(withIdentifier: "PasswordChangeViewController") as! PasswordChangeViewController
            
            
            self.navigationController?.pushViewController(changePwVC, animated: true)
        }
    }
    
    
}

enum CellModel {
    case passwordChange
    case deviceAuth
}
