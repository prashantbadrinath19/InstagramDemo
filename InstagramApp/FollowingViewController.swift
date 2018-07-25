//
//  FollowingViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/6/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import FirebaseAuth

class FollowingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userFollowArr: Array<User> = []
    var currentUserobj: User?
    var curFollowUserID: String = ""
    @IBOutlet weak var followingTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar
        
        curFollowUserID = (Auth.auth().currentUser?.uid)!
        getAllFollowingUsers()
        
        
        // Do any additional setup after loading the view.
    }
    
    func getAllFollowingUsers()
    {
        FirebaseHandler.sharedInstance.getSingleUser(userID: curFollowUserID) { (user) in
            if user.Following.count > 0
            {
                FirebaseHandler.sharedInstance.getFollowingUsers(users: user.Following, completion: { (usersArr, error) in
                    self.userFollowArr = usersArr
                    self.followingTableView.reloadData()
                })
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userFollowArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingID") as? FollowingTableViewCell
        let user = userFollowArr[indexPath.row]
        
        cell?.followUserNameLbl.text = user.FullName
        cell?.followUserImageView.sd_setImage(with: URL(string: user.UserImage!), placeholderImage: UIImage(named: "DefaultUserImage"))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj_ChatVC = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        let friendobj = userFollowArr[indexPath.row]
        obj_ChatVC.friendObj = friendobj
        obj_ChatVC.isFriend = true
        navigationController?.pushViewController(obj_ChatVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getAllFollowingUsers()
    }

   
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
