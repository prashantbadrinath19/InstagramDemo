//
//  HomePageViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/28/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import TWMessageBarManager
import SDWebImage


class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tblViewPost: UITableView!
    
    var postStorageRef = StorageReference()
    var postDatabaseRef = DatabaseReference()
    var postArr : Array<Post> = []
    var currentUserID: String?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        
        navigationItem.hidesBackButton = true
        
        currentUserID = Auth.auth().currentUser?.uid
        
        postDatabaseRef = Database.database().reference().child("Posts")
        
        refreshControl.isEnabled = true
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tblViewPost.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func refreshAction() {
        
        postArr.removeAll()
        fetchAllPost()
        
    }
    

    func fetchAllPost(){
        FirebaseHandler.sharedInstance.getAllPost { (postArr) in
            self.postArr = postArr
            DispatchQueue.main.async {
                self.tblViewPost.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        loadAllPostData()
    }
    
    func loadAllPostData() {
        FirebaseHandler.sharedInstance.getAllPost { (postArr) in
            self.postArr = postArr
            DispatchQueue.main.async {
                self.tblViewPost.reloadData()
            }
        }
    }
    @IBAction func cameraButAction(_ sender: Any) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController
        {
            navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    
    @IBAction func btnSendMessage(_ sender: Any) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "FollowingViewController") as? FollowingViewController{
        
        navigationController?.pushViewController(controller, animated: true)
    }
    }
    
    
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCellId") as! PostTableViewCell
        let post = postArr[indexPath.row]
        cell.nameLbl.text = post.userobj?.FullName
        cell.descriptionLbl.text = post.postDiscription
//        let date = Date(timeIntervalSince1970: Double(post.timestamp))
//        let dateformatter = DateFormatter()
//        dateformatter.dateStyle = .long
        
        cell.postTimestampLbl.text = post.timestamp.timeElapsed
        
        
        let userImageurl = URL(string: (post.userobj?.UserImage)!)
        
        //cell.dpImageView.sd_setImage(with: userImageurl, placeholderImage: UIImage(named: "DefaultUserImage"))
        
        let postImageurl = URL(string: post.postImage)
        
       // cell.postImageView.sd_setImage(with: postImageurl!, completed: nil)
        
        let count = post.userLIked?.count ?? 0
        cell.like_count.setTitle("\(count) Likes", for: .normal)
        
        if let userlikedArr = post.userLIked
        {
            cell.likeButtonAction.isSelected = userlikedArr.contains(currentUserID!)
        }
        else
        {
            cell.likeButtonAction.isSelected = false
        }
        
        cell.likeButtonAction.addTarget(self, action: #selector(btnLikeACtion), for: .touchUpInside)
        cell.likeButtonAction.tag = indexPath.row
        cell.like_count.tag = indexPath.row
        cell.like_count.addTarget(self, action: #selector(goToUserLikedVC), for: .touchUpInside)
        
        cell.comment_btn.tag = indexPath.row
        cell.comment_btn.addTarget(self, action: #selector(comment_btn_Clicked), for: .touchUpInside)
        return cell
    }
    
    
    
    
    
    @objc func goToUserLikedVC(sender: UIButton)
    {
        
        let obj_UserLikedVC = self.storyboard?.instantiateViewController(withIdentifier: "UserLikedVC") as! UserLikedVC
        let post = postArr[sender.tag]
        print(sender.tag)
        if let userLikedArr = post.userLIked
        {
            obj_UserLikedVC.userLikedArr = userLikedArr
            navigationController?.pushViewController(obj_UserLikedVC, animated: true)
        }
    }
    
    @objc func btnLikeACtion(sender: UIButton)
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let obj = tblViewPost.cellForRow(at: indexpath) as! PostTableViewCell
        sender.isSelected = !sender.isSelected
        let postdetail = postArr[sender.tag]
        var count = postdetail.userLIked?.count ?? 0
        
        if !sender.isSelected
        {
            postdetail.userLIked =  postdetail.userLIked?.filter{$0 != currentUserID!}
            count = count - 1
            obj.like_count.setTitle("\(count) Likes", for: .normal)
            FirebaseHandler.sharedInstance.unlikePost(uid: currentUserID!, postid: postdetail.postid)
        }
        else
        {
            postdetail.userLIked?.append(currentUserID!)
            count = count + 1
            obj.like_count.setTitle("\(count) Likes", for: .normal)
            FirebaseHandler.sharedInstance.userlikePost(uid: currentUserID! , postid: postdetail.postid)
        }
    }
    
    @objc func comment_btn_Clicked(sender: UIButton)
    {
        let obj_PostCommentVC = storyboard?.instantiateViewController(withIdentifier: "PostCommentVC") as! PostCommentViewController
        obj_PostCommentVC.currentUserID = currentUserID!
        obj_PostCommentVC.postId = postArr[sender.tag].postid
        self.navigationController?.pushViewController(obj_PostCommentVC, animated: true)
    }
    
    
    func setTitle(){
        let titleImage = UIImage(named: "title")
        let imageview = UIImageView(image: titleImage)
        imageview.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageview.contentMode = .scaleAspectFit
        navigationItem.titleView = imageview
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

extension Double {
    // MARK: Need to edit
    var timeElapsed: String {
        let elapseSeconds = Int(Date().timeIntervalSince1970 - self)
        let hr = elapseSeconds / 3600
        let days = hr / 24
        let remainder = elapseSeconds - hr * 3600
        let min = remainder / 60
        
        // check days
        if days == 1 {
            return "\(days) DAY AGO"
        } else if days > 1 {
            return "\(days) DAYS AGO"
        }
        
        // check hrs
        if hr == 1 {
            return "\(hr) HOUR AGO"
        } else if hr > 1 {
            return "\(hr) HOURS AGO"
        }
        
        // check minutes
        if min == 1 {
            return "\(min) MINUTE AGO"
        } else if min > 1 {
            return "\(min) MINUTES AGO"
        }
        
        return "JUST NOW"
}
    var readableTime: String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

