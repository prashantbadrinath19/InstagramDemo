//
//  PostCommentViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/7/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import FirebaseAuth

class PostCommentViewController: UIViewController {

    
     var commentArr: Array<Comment> = []
    
    
    @IBOutlet weak var comment_tableView: UITableView!
    @IBOutlet weak var writeComment: UITextField!
    @IBOutlet weak var currentUserImage: UIImageView!
    @IBOutlet weak var writeCommentView: UIView!
    
    var currentUserID: String = ""
    var postId: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        currentUserImage.layer.cornerRadius = currentUserImage.frame.size.height/2
        currentUserImage.layer.borderWidth = 1.0
        currentUserImage.layer.borderColor = UIColor.black.cgColor
        
        currentUserID = (Auth.auth().currentUser?.uid)!
        NotificationCenter.default.addObserver(self, selector: #selector(PostCommentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostCommentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        getAllCommentsForSelectedPost()
        setupBottomWriteCommentView()
        
        // Do any additional setup after loading the view.
    }
    
    
   

    
    func getAllCommentsForSelectedPost()
    {
        FirebaseHandler.sharedInstance.getAllComments(postId: postId) { (comments) in
            self.commentArr = comments
            DispatchQueue.main.async {
                self.comment_tableView.reloadData()
            }
            
            
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        }
        
        
        
        
        func setupBottomWriteCommentView()
        {
            FirebaseHandler.sharedInstance.getSingleUser(userID: currentUserID) { (user) in
                let url = URL(string: user.UserImage!)
                self.currentUserImage.sd_setImage(with: url!, completed: nil)
            }
        }
    
    
    @IBAction func postComment(_ sender: Any)
    {
       
        FirebaseHandler.sharedInstance.postComment(postId: postId, currentuserId: currentUserID, comment: writeComment.text!)
        
        writeComment.text = ""
        getAllCommentsForSelectedPost()
        
        
    }
       
        
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


    extension PostCommentViewController: UITableViewDataSource, UITableViewDelegate
    {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return commentArr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentTVC") as! PostCommentTableViewCell
            let comment = commentArr[indexPath.row]
            
            cell.userName.text = comment.objUser.FullName
            cell.userComment.text = comment.comment
            let timelapase = comment.timestamp.timeElapsed
            cell.timeEnlapsed.text = timelapase
            
            cell.userImage.sd_setImage(with: URL(string: comment.objUser.UserImage!), completed: nil)
            
            return cell
        }
    }
    
    extension PostCommentViewController: UITextFieldDelegate
    {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            textField.resignFirstResponder()
            return true
        }
}


