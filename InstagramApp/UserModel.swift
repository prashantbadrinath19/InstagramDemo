//
//  UserModel.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/29/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import Foundation


struct User {
    let EmailID: String?
    let UserID: String?
    let FullName: String?
    let PhoneNo: String?
    let UserImage: String?
    var posts: Array<String> = []
    var Following: Array<String> = []
}


   
