//
//  PostViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/30/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import TWMessageBarManager
import SVProgressHUD
//import AlamofireImage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let imagePicker = UIImagePickerController()
    var userDatabaseRef: DatabaseReference?
    var userStorageRef: StorageReference?
    let curUserID = Auth.auth().currentUser?.uid
    var key = ""
    
    @IBOutlet weak var imgViewPost: UIImageView!
    @IBOutlet weak var txtViewPost: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
        imagePicker.delegate = self
        userDatabaseRef = Database.database().reference()
        userStorageRef = Storage.storage().reference()
        key = (userDatabaseRef?.child("Posts").childByAutoId().key)!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        imagePicker.allowsEditing = true
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func createPost() {
        let timeStamp = Int(Date().timeIntervalSince1970)
        let timeStampString = String(timeStamp)
        
        if Auth.auth().currentUser != nil {
            let userImage = self.imgViewPost.image
            if userImage != nil {
               // let reducedsizeimg = userImage?.af_imageScaled(to: CGSize(width: 320, height: 180))
                let data = UIImagePNGRepresentation(userImage!)
               // let data = UIImagePNGRepresentation(userImage!)
                let metadata = StorageMetadata()
                metadata.contentType = "image/png"
                let imageName = "PostImages/\((self.key)).png"
                userStorageRef = userStorageRef?.child(imageName)
                SVProgressHUD.show()
                
                self.userStorageRef?.putData(data!, metadata: metadata, completion: { (meta, error) in
                    if let err = error
                    {
                        SVProgressHUD.dismiss()
                        TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        self.userStorageRef?.downloadURL(completion: { (url, error) in
                            if error == nil
                            {
                                let post = ["PostID": self.key, "Description": self.txtViewPost.text!, "Timestamp": timeStampString, "UserID": self.curUserID!, "ImageRef" : url!.absoluteString] as [String: Any]
                                self.userDatabaseRef?.child("Posts").child(self.key).updateChildValues(post)
                                
                                let postForCurUser = [self.key: true]
                                self.userDatabaseRef?.child("Users").child(self.curUserID!).child("posts").updateChildValues(postForCurUser)
                                
                                SVProgressHUD.dismiss()
                                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Successfully added a Post", type: .success)
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                        //self.navigationController?.popViewController(animated: true)
                    }
                    
                   
                })
            }
            else{
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "No Image Selected", description: "Please Select an Image using the camera Icon Below", type: .error)
            }
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imgViewPost.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @IBAction func btnPost(_ sender: Any) {
        createPost()
      
    }
    
    @IBAction func btnCancel(_ sender: Any) {
            navigationController?.popViewController(animated: true)
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
