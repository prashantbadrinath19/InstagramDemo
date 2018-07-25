//
//  ChatVC.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/9/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseDatabase


class ChatVC: JSQMessagesViewController
{
    var currentUserName: String = ""
    var currentUserId: String?
    var isFriend = false
    var friendObj: User?
    var messages:Array<ChatMessages> = []
    var chatMessagesArray : Array<ChatMessages> = []
    var ref: DatabaseReference?
    private lazy var notificationRef = Database.database().reference().child("notificationRequests")
    private lazy var conversationRef = Database.database().reference().child("Conversations")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserId = Auth.auth().currentUser?.uid
        
        ref = Database.database().reference()
        title = "Chat"
        if isFriend
        {
            collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "patternBackground")!)
            tabBarController?.tabBar.isHidden = true
            title = friendObj?.FullName
            senderId = currentUserId
            senderDisplayName = currentUserName
            collectionView.backgroundView = UIImageView(image: UIImage(named: "bckgroundIMg"))
            messages = getMessages()
        }
        else{
            senderId = currentUserId
            messages = getMessages()
        }

        // Do any additional setup after loading the view.
    }
    
    func getMessages() -> [ChatMessages] {
        messages = []
        chatMessagesArray = []
        var convoKey: String = ""
        
        if (friendObj?.UserID)! < currentUserId!{
            convoKey = (friendObj?.UserID)! + "" + currentUserId!
        }
        else
        {
            convoKey = currentUserId! + (friendObj?.UserID)!
        }
        //queryOrderedByKey().
        ref?.child("Conversations/\(convoKey)").observe(.value, with: { (snapshot) in
            self.messages = []
            self.chatMessagesArray = []
            guard let value = snapshot.value as? NSDictionary else {return}
            for item in value {
                let msgDict = item.value as? Dictionary<String,String>
                let msg =  JSQMessage(senderId: msgDict?["Sender ID"], displayName: "", text: msgDict?["Message"])
                let chatMsg = ChatMessages(msg: msg!, tStamp: Int(item.key as! String)!)
                
                self.messages.append(chatMsg)
            }
            self.chatMessagesArray = self.messages.sorted(by: { (obj1, obj2) -> Bool in
                
                let ts1 = obj1.timeStamp
                let ts2 = obj2.timeStamp
                
                return(ts1 < ts2)
            })
            print(self.chatMessagesArray.count)
            //print(self.messages)
            self.collectionView.reloadData()
            
        })
        self.collectionView.reloadData()
        return messages
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("here \(messages.count)")
        return chatMessagesArray.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = chatMessagesArray[indexPath.row].message
        
        if currentUserId! == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        scrollToBottom(animated: true)
        let message = chatMessagesArray[indexPath.row].message
        let messageUsername = message.senderDisplayName
        
        return NSAttributedString(string: messageUsername!)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return chatMessagesArray[indexPath.row].message
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        
        // Adding Nodes for one on one push notifications
        sendMsgTo(receiverId: (friendObj?.UserID)!, with: (message?.text)!)
        finishSendingMessage()
        
    }
    
    func sendMsgTo(receiverId: String, with msg: String) {
        
        /*
        let conversationRef = Database.database().reference().child("Conversations")
        let notificationRef = Database.database().reference().child("notificationRequests")
        let ts = Int(timeStamp())
        // send message to firebase database
        let conv = ["Sender ID": currentUserId!,
                    "Message": msg]
        // make sure we have the same order for convkey between two people
        var convKey: String = ""
        if receiverId < currentUserId!
        {
            convKey = receiverId + currentUserId!
        }
        else
        {
            convKey = currentUserId! + receiverId
        }
        
        let convUpdates = ["\(convKey)/\(Int(ts))": conv]
        conversationRef.updateChildValues(convUpdates)
        
        // send push notification to norificationRequest field in firebase that is observed by node.js server which will observe the change and then route the message to our receiver
        let notificationKey = notificationRef.childByAutoId().key
        let notification = ["message": msg, "receiverId": receiverId, "senderId": currentUserId!]
        
        let notificationUpdate = [notificationKey: notification]
        notificationRef.updateChildValues(notificationUpdate)
         */
        
        let recID = (friendObj?.UserID)!
        
        //send message to firebase database
        let conv = ["Sender ID": currentUserId!,
                    "Message": msg]
        
        // make sure we have the same order for convkey between two people
        var convKey: String = ""
        
        if recID < currentUserId!
        {
            convKey = recID + currentUserId!
        }else {
            convKey = currentUserId! + recID
        }
        
        let convUpdates = ["\(convKey)/\(Int(Date().timeIntervalSince1970))": conv]
        conversationRef.updateChildValues(convUpdates)
        
        // send push notification to norificationRequest field in firebase that is observed by node.js server which will observe the change and then route the message to our receiver
        
        
        
        let notificationKey = notificationRef.childByAutoId().key
        let notification = ["message": msg, "receiverId": recID, "senderId": currentUserId!]
        
        let notificationUpdate = [notificationKey: notification]
        notificationRef.updateChildValues(notificationUpdate)
    }
    
    
    func timeStamp() -> Double {
        let timestamp = Date().timeIntervalSince1970
        let reversedTimestamp = -1.0 * timestamp
        return reversedTimestamp
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
