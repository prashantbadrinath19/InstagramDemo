//
//  ResetPasswordViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/29/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TWMessageBarManager

class ResetPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTxtFld: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func resetPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailTxtFld.text!) { (error) in
            if error == nil
            {
                TWMessageBarManager().showMessage(withTitle: "Link to reset password set on your email", description: error?.localizedDescription, type: .success)
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                TWMessageBarManager().showMessage(withTitle: "unable to change password, please enter correct email address.", description: error?.localizedDescription, type: .error)
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
