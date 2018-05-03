//
//  LoginViewController.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/9/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var loginBtn : UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var username: CustomTextField!
    
    @IBOutlet weak var password: CustomTextField!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail(completion: { (success) in
                if success{
                    self.performSegue(withIdentifier: "RevealViewController", sender: self)
                }
            })
        }
        else{
            super.viewDidLoad()
            setupView()
        }
    }
    @IBAction func loginBtnTouched(_ sender: UIButton) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = username.text, username.text != "" else { return }
        guard let passwordText = password.text, password.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: passwordText) { (success) in
            if success{
            AuthService.instance.findUserByEmail(completion: { (success) in
                    if success{
                            self.performSegue(withIdentifier: "RevealViewController", sender: self)
                    }
                })
            }
        }
        
        performSegue(withIdentifier: "RevealViewController", sender: self)
    }
    
    
    @IBAction func createBtnTouched(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateAccountViewController", sender: self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLoginViewController(segue:UIStoryboardSegue) { }

    func setupView() -> Void {
        
        spinner.isHidden = true
    }
    
}
