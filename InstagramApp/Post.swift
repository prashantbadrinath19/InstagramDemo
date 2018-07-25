//
//  Post.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/31/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import Foundation

class Post
{
    var postid: String
    var userid: String
    var postImage: String
    var timestamp: Double
    var userLIked: [String]?
    var userobj: User?
    var postDiscription: String?
    var comments: [String: String] = [:]
    
    init( postid: String, userid: String, postImage: String, timestamp: Double, userLIked: [String]?, userobj: User?, postDiscription: String?, comments: [String: String]) {
        self.postid = postid
        self.userLIked = userLIked
        self.userid = userid
        self.timestamp = timestamp
        self.userobj = userobj
        self.postDiscription = postDiscription
        self.postImage = postImage
        self.comments = comments
    }

}

class Comment{
    var commentId: String
    var userId: String
    var comment: String
    var postId: String
    var timestamp: Double
    var objUser: User
    init(commentId:String,userId:String, comment:String, postId: String, timestamp: Double, objUser: User)
    {
        self.commentId = commentId
        self.comment = comment
        self.userId = userId
        self.postId = postId
        self.timestamp = timestamp
        self.objUser = objUser
    }
}
