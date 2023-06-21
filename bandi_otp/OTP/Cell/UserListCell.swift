//
//  UserListCell.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/14.
//

import UIKit

class UserListCell: UITableViewCell {
    
    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var otpUserLabel: UILabel!
    
    weak var delegate: ButtonTappedDelegateProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        delegate?.clickDeleteButton(cell: self)
    }
    
    
}

protocol ButtonTappedDelegateProtocol: AnyObject {
    func clickDeleteButton(cell: UserListCell)
}
