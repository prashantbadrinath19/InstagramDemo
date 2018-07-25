//
//  EditProfileViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/28/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD
//import AlamofireImage


import TWMessageBarManager

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userRef: DatabaseReference?
    var userStorageRef: StorageReference?
    
    let imagePicker = UIImagePickerController()
    
     @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationController?.navigationBar.isHidden = true
        userRef = Database.database().reference().child("Users")
        userStorageRef = Storage.storage().reference()
        imagePicker.delegate = self
        imgView.layer.cornerRadius = imgView.frame.size.height/2
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func doneAction(_ sender: Any) {
        if let curUser = Auth.auth().currentUser {
            let userImage = self.imgView.image
            if userImage != nil{
//                let reducedsizeimg = userImage?.af_imageScaled(to: CGSize(width: 50, height: 50))
                let data = UIImagePNGRepresentation(userImage!)
              
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/png"
                let imageName = "UserImage/\(String(describing: curUser.uid)).png"
                userStorageRef = userStorageRef?.child(imageName)
                    SVProgressHUD.show()
                userStorageRef?.putData(data!, metadata: metadata, completion: { (meta, error) in
                    if let err = error
                    {
                        SVProgressHUD.dismiss()
                        TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
                    }
                    else
                    {
                        self.userStorageRef?.downloadURL(completion: { (url, error) in
                            if error == nil
                            {
                                let urlStr = url?.absoluteString
                                let userDict = ["UserImage": urlStr!]
                                self.userRef?.child(curUser.uid).updateChildValues(userDict, withCompletionBlock: { (error, ref) in
                                    if error != nil
                                    {
                                        SVProgressHUD.dismiss()
                                        TWMessageBarManager().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    else
                                    {
                                        SVProgressHUD.dismiss()
                                        TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "You have succesfully uploaded your image", type: .success)
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                })
                            }
                        })
                        
                    }
                    
                })
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    
    @IBAction func changeImageAction(_ sender: Any) {
        imagePicker.allowsEditing = true
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
