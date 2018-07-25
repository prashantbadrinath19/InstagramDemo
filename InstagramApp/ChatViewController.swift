//
//  ChatViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/4/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatViewController: UIViewController {
    
    
    private lazy var notificationRef = Database.database().reference().child("notificationRequests")
    private lazy var conversationRef = Database.database().reference().child("Conversations")
    

    @IBAction func sendMessageAction(_ sender: Any) {
        
        let curUser = Auth.auth().currentUser!
        
        let recID = "ehJezFJTPqOAElPoNJIzWQYXgZ63"
        
        //send message to firebase database
        let conv = ["Sender ID": curUser.uid,
                    "Message": "Like kokk"]
        
        // make sure we have the same order for convkey between two people
        var convKey: String = ""
        
        if recID < curUser.uid{
            convKey = recID + curUser.uid
        }else {
            convKey = curUser.uid + recID
        }
        
        let convUpdates = ["\(convKey)/\(Int(Date().timeIntervalSince1970))": conv]
        conversationRef.updateChildValues(convUpdates)
        
        // send push notification to norificationRequest field in firebase that is observed by node.js server which will observe the change and then route the message to our receiver
        
        
        
        let notificationKey = notificationRef.childByAutoId().key
        let notification = ["message": "Hello", "receiverId": recID, "senderId": curUser.uid]
        
        let notificationUpdate = [notificationKey: notification]
        notificationRef.updateChildValues(notificationUpdate)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
