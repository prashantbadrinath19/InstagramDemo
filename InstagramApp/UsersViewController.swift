//
//  UsersViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/29/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var usersArr: Array<User> = []
    var currentUserID: String?
    var currentUserobj: User?
    
    @IBOutlet weak var userTblView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserID = Auth.auth().currentUser?.uid
        showAllUsers()

        // Do any additional setup after loading the view.
    }
    
    
    func showAllUsers()
    {
        FirebaseHandler.sharedInstance.getAllUsers { (usersArray, error) in
            if error == nil{
                self.usersArr = usersArray
                DispatchQueue.main.async
                    {
                        self.userTblView.reloadData()
                }
            }
        }
        FirebaseHandler.sharedInstance.getSingleUser(userID: currentUserID!) { (user) in
            self.currentUserobj = user
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? UsersTableViewCell
        let user = usersArr[indexPath.row]
        
        cell?.usernameLabl.text = user.FullName
        cell?.profileImageView.sd_setImage(with: URL(string: user.UserImage!), completed: nil)
         let url = URL(string: user.UserImage!)
        cell?.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "DefaultUserImage"))
        if (currentUserobj?.Following.contains(user.UserID!))!
        {
            cell?.followAction.isSelected = true
        }
        else
        {
            cell?.followAction.isSelected = false
        }
        
        
    
        cell?.followAction.addTarget(self, action: #selector(btnFollowACtion), for: .touchUpInside)
        
        cell?.followAction.tag = indexPath.row

        
        
        return cell!
    }
    
    
    @objc func btnFollowACtion(sender: UIButton)
    {
        let user = usersArr[sender.tag]
        sender.isSelected = !sender.isSelected
        
        if !sender.isSelected
        {
            FirebaseHandler.sharedInstance.removeUserfromFollowing(userid: user.UserID!, currentUserId: currentUserID!)
        }
        else
        {
            FirebaseHandler.sharedInstance.addFollowing(userid: user.UserID!, currentUserId: currentUserID!)
        }
        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       showAllUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
