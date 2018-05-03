//
//  CreateAccountViewController.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/10/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var usernameTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var chooseAvatarBtn: UIButton!
    
    @IBOutlet weak var genBackgroundColorBtn: UIButton!
    
    //variables
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector (CreateAccountViewController.handleTap))
        spinner.isHidden = true
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() -> Void {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            avatarImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
        }
    }
    
    @IBAction func createBtnTouched(_ sender: Any) {
        
        enableTextFields()
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = emailTextField.text , emailTextField.text != ""
            else { return  }

        guard let password = passwordTextField.text , passwordTextField.text != ""
            else { return  }

        guard let name = usernameTextField.text , usernameTextField.text != ""
            else { return  }

        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success{
                
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                let alert = UIAlertController(title: "Smack Chat", message: "User Registered", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                    self.spinner.isHidden = false
                                    self.spinner.stopAnimating()
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    self.performSegue(withIdentifier: "RevealViewController", sender: self)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
            else{
                self.enableTextFields()
            }
        }

    }
    @IBAction func backBtnTouched(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLoginViewController", sender: self)

    }
    @IBAction func chooseAvatarBtnTouched(_ sender: Any) {
        performSegue(withIdentifier: "CreateAvatarViewController", sender: self)
    }
    
    
    @IBAction func genBGColor(_ sender: Any) {
        
        let red = CGFloat(arc4random_uniform(255))/255
        let green = CGFloat(arc4random_uniform(255))/255
        let blue = CGFloat(arc4random_uniform(255))/255
        
        bgColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        avatarColor = "[\(red), \(green), \(blue), \(1)]"
        UIView.animate(withDuration: 0.2){
            self.avatarImg.backgroundColor = self.bgColor
        }
    }
    
    func enableTextFields() -> Void {
        usernameTextField.isEnabled = !usernameTextField.isEnabled
        emailTextField.isEnabled = !emailTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        
        chooseAvatarBtn.isEnabled = !chooseAvatarBtn.isEnabled
        genBackgroundColorBtn.isEnabled = !genBackgroundColorBtn.isEnabled
        
    }
    
    
}
