//
//  OptionViewController.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/28/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class OptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let header = ["Account", "Privacy and Security", "Notifications", "Support", "About", "Logins"]
    let set = [["Password","Saved", "Payments", "Original Photos", "Search History", "Language"], ["Account Provacy","Blocked Accounts", "Activity Status", "Story Controls", "Comment Controls", "Account Data", "Two-Factor Authentication", "Data Download", "Privacy and Security Help"], ["Push Notifications","Email and SMS Notifications"], ["Help Center", "Report a Problem"], ["App Updates","Ads","Proivacy Policy", "Terms of Service"], ["Log out"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return set.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(set[section])
        return set[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
        cell?.textLabel?.text = set[indexPath.section][indexPath.row]
        return cell!
    }
    
    private func destroyToLogin() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        
        // Reset Current User
        //CurrentUser.sharedInstance.dispose()
        
        let authStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = authStoryboard.instantiateViewController(withIdentifier: "loginNavigationControllet") as! UINavigationController
        
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: { completed in
            rootViewController.dismiss(animated: true, completion: nil)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrIndex = set[5]
        if indexPath.row == arrIndex.index(of: "Log out"){
            
            do {
                try Auth.auth().signOut()
                googleLogout()
                destroyToLogin()
            } catch {
                print(error)
            }
            
        }
    }

    
    func googleLogout(){
        GIDSignIn.sharedInstance().signOut()
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
