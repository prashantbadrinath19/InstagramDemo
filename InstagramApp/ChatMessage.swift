//
//  ChatMessage.swift
//  FirebaseUsers
//
//  Created by Viren Patel on 4/9/18.
//  Copyright © 2018 Viren Patel. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class ChatMessages
{
    var message: JSQMessage
    var timeStamp: Int
    
    init(msg: JSQMessage, tStamp: Int) {
        message = msg
        timeStamp = tStamp
    }
}

