//
//  ViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/26/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TWMessageBarManager
import GoogleSignIn
import FirebaseMessaging

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
   
    let overlayTransitioningDelegate = OverlayTransitionDelegate()
    
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBOutlet weak var passwdTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        OperationQueue.main.addOperation {
//            <#code#>
//        }
//        
//        DispatchQueue.main.async {
//            <#code#>
//        }
//        
       
        navigationController?.navigationBar.isHidden = true
        
        
        
//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
//        loginButton.center = view.center
//        view.addSubview(loginButton)
//
//        if let accessToken = AccessToken.current {
//            print("User is logged in with access token: \(accessToken)")
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
     // MARK:- ClassWork
    
    @IBAction func googleSigninAction(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        //code in case of signout
//        GIDSignIn.sharedInstance().signOut()
    }
    
    
    
    
    
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if let _ = error{
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let err = error{
                TWMessageBarManager().showMessage(withTitle: "Error", description: err.localizedDescription, type: .error)
            }else{
                if let firUser = user{
                    print(firUser.uid)
                    print(firUser.displayName)
                    print(firUser.email)
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "InstagramTabBarController") as? InstagramTabBarController{
                        
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    
                }
            }
        }
    }
    
    
    
    @IBAction func resetButtonAction(_ sender: Any) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController{
            
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    @IBAction func loginButAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwdTxt.text!) { (result, error) in
            
            let netStat = Reachability.isConnectedToNetwork()
            
            if netStat == true
            {
            if error != nil{
                
                TWMessageBarManager().showMessage(withTitle: "Unable to Log in", description: "enter correct username and password", type: .error)
                
            }
            else{
                TWMessageBarManager().showMessage(withTitle: "success", description: "Logged in", type: .success)
                let currUser = Auth.auth().currentUser?.uid
                Messaging.messaging().subscribe(toTopic: currUser!)
                
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "InstagramTabBarController") as? InstagramTabBarController
                
                self.navigationController?.pushViewController(controller!, animated: true)
                
            }
        }
                
                else{
                    
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NetworkViewController") as? NetworkViewController {
                        viewController.transitioningDelegate = self.overlayTransitioningDelegate
                        viewController.modalPresentationStyle = .custom
                        self.present(viewController, animated: true, completion: nil)
                        
                }
                
                    
                    
                }
            }
                
        }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    
}

