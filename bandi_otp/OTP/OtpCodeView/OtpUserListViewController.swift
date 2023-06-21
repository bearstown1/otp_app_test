//
//  OtpUserListViewController.swift
//  bandi_otp
//
//  Created by bandisnc on 2023/06/09.
//

import UIKit

class OtpUserListViewController: UIViewController {
    
    @IBOutlet weak var userListTableView: UITableView! {
        didSet {
            userListTableView.delegate = self
            userListTableView.dataSource = self
            
            userListTableView.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "UserListCell")
        }
    }
    
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var userList = [UserList]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightButton = UIBarButtonItem(title: "사용자 추가", style: .plain, target: self, action: #selector(showUserAddForm))
        rightButton.tintColor = .white
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButton
        
        self.fetchData()
        self.userListTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
        self.userListTableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.saveContext()
    }
    
    @objc func showUserAddForm() {
        let storyBoard = UIStoryboard(name: "OtpUserAdd", bundle: nil)

        let otpUserAddVC = storyBoard.instantiateViewController(withIdentifier: "OtpUserAddViewController") as! OtpUserAddViewController
        
        otpUserAddVC.delegate = self
        
        self.navigationController?.pushViewController(otpUserAddVC, animated: true)
    }
    

}

extension OtpUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        cell.otpUserLabel.text = (userList[indexPath.row].user_id ?? "")! + "(" + (userList[indexPath.row].company ?? "") + ")"
        
        effectDeselect(cell: cell)
        if userList[indexPath.row].selectYN || userList.count == 1{
            let path = NSIndexPath(row: indexPath.row, section: 0)
            tableView.selectRow(at: path as IndexPath, animated: false, scrollPosition: .none)
            
            let background = UIView()
            background.backgroundColor = .clear
            cell.selectedBackgroundView = background
            
            cell.otpUserLabel.textColor = .orange
            cell.otpUserLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cell.personImageView.image = UIImage(systemName: "person.circle.fill")
            cell.personImageView.tintColor = .orange
            userList[indexPath.row].selectYN = true
        }

        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserListCell
        userList[indexPath.row].selectYN = true
        effectSelect(cell: cell)
        
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserListCell
        effectDeselect(cell: cell)
        
        userList[indexPath.row].selectYN = false
        
    }
    
    func fetchData() {
        let fetchRequest = UserList.fetchRequest()
        
        do {
            userList = try context.fetch(fetchRequest)
            
        } catch {
            print(error)
        }
    }
    
    func effectSelect(cell: UserListCell) {
        let background = UIView()
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        cell.otpUserLabel.textColor = .orange
        cell.otpUserLabel.font = UIFont.boldSystemFont(ofSize: 16)
        cell.personImageView.image = UIImage(systemName: "person.circle.fill")
        cell.personImageView.tintColor = .orange
    }
    
    func effectDeselect(cell: UserListCell) {
        cell.otpUserLabel.textColor = .black
        cell.personImageView.image = UIImage(systemName: "person.circle")
        cell.personImageView.tintColor = .secondaryLabel
        cell.otpUserLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    
}

extension OtpUserListViewController: OtpUserAddViewControllerProtocol {
    func didFinishSave() {
        self.fetchData()
        self.userListTableView.reloadData()
    }
    
}

extension OtpUserListViewController: ButtonTappedDelegateProtocol {
    func clickDeleteButton(cell: UserListCell) {
        let indexPath = self.userListTableView.indexPath(for: cell)
        
        
        if let row = indexPath?.row{
            if userList[row].selectYN && userList.count != 1{
                userList[0].selectYN = true
            }
            context.delete(userList[row])
            appDelegate.saveContext()
            didFinishSave()
        }
        
    }
    
    
    
}
