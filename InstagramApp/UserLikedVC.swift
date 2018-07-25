//
//  UserLikedVC.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/1/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import SDWebImage
class UserLikedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userLikedTableView: UITableView!
    
    
    var userLikedArr: Array<String> = []
    var userArr: Array<User> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserLiked()
        
        // Do any additional setup after loading the view.
    }
    
    func getUserLiked() {
        FirebaseHandler.sharedInstance.getAllUserLiked(arrUserLiked: userLikedArr) { (userArr, error) in
         self.userArr = userArr
            DispatchQueue.main.async {
                self.userLikedTableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserLikedTVC") as! UserLikedTVC
        let user = userArr[indexPath.row]
        let url = URL(string: user.UserImage!)
        cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "DefaultUserImage"))
        cell.userName.text = user.FullName
        return cell
    
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
