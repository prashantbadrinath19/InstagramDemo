//
//  FirebaseAPIHandler.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/29/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import TWMessageBarManager

typealias  completionhandler = ([User], Error?) -> ()
typealias postCompletionHandler = ([Post]) -> ()
typealias singleUserCompletionHandler = (User) -> ()
typealias commentCompetionHandler = ([Comment]) -> ()




class  FirebaseHandler: NSObject
{

var databasrRef: DatabaseReference = Database.database().reference()
//var userArr: Array<User> = []

private override init(){}
static let sharedInstance = FirebaseHandler()

func getAllUsers(completion: @escaping completionhandler) {
    
    databasrRef.child("Users").observeSingleEvent(of: .value) { (snapshot) in
        var userArr: Array<User> = []

        guard let value = snapshot.value as? [String: Any] else{
            return
        }
        for item in value{
            
            let dict = item.value as! Dictionary<String, Any>
            
            var userPostsArr : Array<String> = []
            var userFollowingArr: Array<String> = []
            if let userpostsdic = dict["posts"] as? [String: Bool]
            {
                for val in userpostsdic
                {
                    userPostsArr.append(val.key)
                }
            }
            let user = User(EmailID: (dict["EmailID"] as! String), UserID: (dict["UserID"] as! String), FullName: (dict["FullName"] as! String), PhoneNo: (dict["PhoneNo"] as! String), UserImage: (dict["UserImage"] as! String), posts: userPostsArr, Following: userFollowingArr)
            
            userArr.append(user)
            
            
        }
        completion(userArr, nil)
    }
    
}
    func getSingleUser(userID: String, completion: @escaping singleUserCompletionHandler)
    {
        
        databasrRef.child("Users/\(userID)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,Any> else
            {
                return
            }
            var obj: User?
            
            var userPostsArr : Array<String> = []
            var userFollowingArr: Array<String> = []
            
            if let userpostsdic = value["posts"] as? [String: Bool]
            {
                for val in userpostsdic
                {
                    userPostsArr.append(val.key)
                }
            }
            
            if let followingUserDic = value["Following"] as? [String: Bool]
            {
                for val in followingUserDic
                {
                    userFollowingArr.append(val.key)
                }
            }
            obj = User(EmailID: (value["EmailID"] as! String), UserID: userID, FullName: (value["FullName"] as! String), PhoneNo: value["PhoneNo"] as? String, UserImage: value["UserImage"] as? String, posts: userPostsArr, Following: userFollowingArr)
            completion(obj!)
        }
        
    }
    
    func addFollowing(userid: String, currentUserId: String)
    {
        let follwingDic = [userid: true]
        self.databasrRef.child("Users").child(currentUserId).child("Following").updateChildValues(follwingDic) { (error, ref) in
            if error != nil
            {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
        }
    }
    
    func removeUserfromFollowing(userid: String, currentUserId: String)
    {
        databasrRef.child("Users/\(currentUserId)").child("Following").child(userid).removeValue()
    }
    
    
    func getAllPost(completion: @escaping postCompletionHandler)
    {
        databasrRef.child("Posts").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,Any> else
            {
                completion([])
                return
            }
            var postArr : Array<Post> = []
            for item in value
            {
                if let post = item.value as? Dictionary<String,Any>
                {
                    var userLikedArr: [String] = []
                    if let userLiked = post["UserLiked"] as? [String: Bool]
                    {
                        for item in userLiked
                        {
                            userLikedArr.append(item.key)
                        }
                    }
                    var commentDictionary: Dictionary<String,String> = [:]
                    if let commentDic = value["Comment"] as? Dictionary<String,String>
                    {
                        commentDictionary = commentDic
                    }
                    
                    
                    FirebaseHandler.sharedInstance.getSingleUser(userID: post["UserID"] as! String, completion: { (user) in

                        let objPost = Post(postid: post["PostID"] as! String, userid: user.UserID!, postImage: post["ImageRef"] as! String, timestamp: Double(post["Timestamp"] as! String)!, userLIked: userLikedArr, userobj: user, postDiscription: post["Description"] as! String, comments: commentDictionary)
                        
                        
                        postArr.append(objPost)
                        
                        postArr.sort(by: {$0.timestamp > $1.timestamp})
                        completion(postArr)
                    })
                }
            }
        }
    }
    
    
    func getFollowingUsers(users: Array<String>, completion: @escaping completionhandler)
    {
        var usersArr: Array<User> = []
        for userid in users
        {
            FirebaseHandler.sharedInstance.getSingleUser(userID: userid) { (user) in
                usersArr.append(user)
                completion(usersArr, nil)
            }
        }
    }
    
    
    func getPostByID(posts: [String], completion: @escaping (([Post]) -> Void)) {
        
        var resArray: [Post] = []
        let group = DispatchGroup()
        
        for item in posts {
            
           // group.enter()
            databasrRef.child("Posts").child(item).observeSingleEvent(of: .value, with: {(snapshot) in
                guard let value = snapshot.value as? Dictionary<String,Any> else
                {
                    completion([])
                    return
                }
                
                var commentDictionary: Dictionary<String,String> = [:]
                if let commentDic = value["Comment"] as? Dictionary<String,String>
                {
                    commentDictionary = commentDic
                }
                
                let postData = Post(postid: value["PostID"] as! String, userid: value["UserID"] as! String, postImage: value["ImageRef"] as! String, timestamp: Double(value["Timestamp"] as! String)!, userLIked: value["UserLiked"] as? [String], userobj: nil, postDiscription: value["Description"] as? String, comments: commentDictionary)
                //print(postData)
                 resArray.sort(by: {$0.timestamp > $1.timestamp})
                resArray.append(postData)
               // group.leave()
                
                completion(resArray)
            })
        }
       // group.notify(queue: .main) {
        
        //}
        
    }
    
    
    func userlikePost(uid: String, postid: String)
    {
        let userdic = [uid: true] as [String : Bool]
        databasrRef.child("Posts/\(postid)").child("UserLiked").updateChildValues(userdic)
    }
    
    func unlikePost(uid: String, postid: String)
    {
        databasrRef.child("Posts/\(postid)").child("UserLiked").child(uid).removeValue()
    }
    
    func getAllUserLiked(arrUserLiked: [String], completion: @escaping  completionhandler){
        
        var userArr: Array<User> = []
        for userID in arrUserLiked
        {
        
            FirebaseHandler.sharedInstance.getSingleUser(userID: userID) { (user) in
                userArr.append(user)
                completion(userArr, nil)
            }
            
        }
       
        
        
    }
    
    func postComment(postId: String, currentuserId: String, comment: String)
    {
        
        let timeStamp = Int(Date().timeIntervalSince1970)
        let commentDict = ["userId": currentuserId,"postId": postId, "comment": comment, "timestamp": timeStamp] as [String : Any]
        
        
        let commentId = databasrRef.child("Posts").child(postId).child("Comment").childByAutoId().key
        self.databasrRef.child("Posts").child(postId).child("Comment").child(commentId).updateChildValues(commentDict, withCompletionBlock: { (error, ref) in
            if let err = error {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            }
            else
            {
                //TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "You have just posted a comment", type: .success)
            }
        })
    }
    
    func getAllComments(postId: String, completion: @escaping commentCompetionHandler)
    {
        databasrRef.child("Posts").child(postId).child("Comment").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? Dictionary<String,Any> else
            {
                completion([])
                return
            }
            
            var commentArr : Array<Comment> = []
            
            for item in value
            {
                if let commentDic = item.value as? Dictionary<String,Any>
                {
                    FirebaseHandler.sharedInstance.getSingleUser(userID: commentDic["userId"] as! String, completion: { (user) in
                        
                        let comment = Comment(commentId: item.key, userId: commentDic["userId"] as! String, comment: commentDic["comment"] as! String, postId: commentDic["postId"] as! String, timestamp: commentDic["timestamp"] as! Double, objUser: user)
                        
                        commentArr.append(comment)
                        print(commentArr)
                        //postArr.append(objPost)
                        commentArr.sort(by: {$0.timestamp < $1.timestamp})
                        completion(commentArr)
                    })
                }
            }
            
        }
    }
    
    
}
    
    

