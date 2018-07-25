//
//  PorfileViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/28/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import TWMessageBarManager
import SDWebImage



class PorfileViewController: UIViewController, UICollectionViewDataSource {
   
    
    var postArr: Array<Post> = []
    
    
    @IBOutlet weak var postCollectonView: UICollectionView!
    
    
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dpImageView: UIImageView!
   
    var userStorageRef = StorageReference()
   // var userDatabaseRef = DatabaseReference()
    var userDatabaseRef = Database.database().reference()
    var currentUserId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dpImageView.layer.cornerRadius = dpImageView.frame.size.height/2
        dpImageView.layer.borderWidth = 1.0
        dpImageView.layer.borderColor = UIColor.black.cgColor
        postCollectonView.collectionViewLayout = CustomCollectionViewFlowLayout()
        currentUserId = Auth.auth().currentUser?.uid
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        FirebaseHandler.sharedInstance.getSingleUser(userID: currentUserId!) { (user) in
            let url = URL(string: user.UserImage!)
            self.dpImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "DefaultUserImage"))
//            navigationController?.
            self.userName.text = user.FullName
            self.postCount.text = "\(user.posts.count)"
            if user.posts.count > 0
            {
                FirebaseHandler.sharedInstance.getPostByID(posts: user.posts, completion: { (posts) in
                    self.postArr = posts
                    self.postCollectonView.reloadData()
                })
            }
        }
       // loadData()
    }
    /*
    func loadData() {
        
    userDatabaseRef.child("Users").child(currentUserId!).child("posts").observeSingleEvent(of: .value, with: {(snapshot) in
            guard let value = snapshot.value as? Dictionary<String, Any> else
            {
                print("Counldn't het the data")
                return
            }
            if let postIDs = value as? [String:Bool]{
                FirebaseHandler.sharedInstance.getPostByID(posts: postIDs, completion: { (posts) in
                    print(posts)
                    self.postArr = posts
                    self.postCollectonView.reloadData()
                })
            }
        })
        
    }
 */
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print(postArr.count)
        return postArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell
        let post = postArr[indexPath.row]
        let url = URL(string: post.postImage)
        cell?.userPostImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "DefaultUserImage"))
        
        return cell!
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


