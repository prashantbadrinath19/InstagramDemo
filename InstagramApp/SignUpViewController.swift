//
//  SignUpViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/28/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TWMessageBarManager
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: BaseViewController {

    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwdTxt: UITextField!
    
    @IBOutlet weak var fullNameText: UITextField!
    
    @IBOutlet weak var phoneNumberTxt: UITextField!
    
    
    var userRef: DatabaseReference?
    var userStorageRef: StorageReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRef = Database.database().reference().child("Users")
        userStorageRef = Storage.storage().reference()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTxt.text!, password: passwdTxt.text!) { (result, error) in
            if error != nil
            {
                TWMessageBarManager().showMessage(withTitle: "error", description: error?.localizedDescription, type: .error)
                //print(error)
            }
            else{
                TWMessageBarManager().showMessage(withTitle: "Account Created", description: "Now login", type: .success)
                
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                    self.navigationController?.popViewController(animated: true)
                }
                
                
                if let firstUser = result?.user {
                    let userDict = ["EmailID": firstUser.email, "UserID": firstUser.uid, "FullName": self.fullNameText.text!, "PhoneNo": self.phoneNumberTxt.text!, "UserImage": ""]
                    self.userRef?.child(firstUser.uid).updateChildValues(userDict, withCompletionBlock: { (error, ref) in
                        if error == nil{
                            print("its working")
                        } else{
                            TWMessageBarManager().showMessage(withTitle: "error", description: error?.localizedDescription, type: .error)
                        }
                    })
                }
            }
        }
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
