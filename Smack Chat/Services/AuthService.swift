//
//  AuthService.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/10/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get{
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String{
        get{
            guard let token = defaults.value(forKey: TOKEN_KEY) as? String else { return "" }
            return token
        }
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get{
            guard let email = defaults.value(forKey: USER_EMAIL) as? String
                else {
                    return ""
            }
            return email
        }
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }

    }
    
    func registerUser(email: String, password: String, completion : @escaping CompletionHandler) -> Void {
        
        let lowerCaseEmail = email.lowercased()
        
        let body : [String : Any] = [
        "email" : lowerCaseEmail,
        "password" : password
        ]
        
        Alamofire.request(REGISTER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER)
            .responseString{ (response) in
            if response.result.error == nil{
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }

    func loginUser(email: String, password: String, completion : @escaping CompletionHandler) -> Void {
        
        let lowerCaseEmail = email.lowercased()
        let body : [String : Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER)
            .responseJSON{ (response) in
                if response.result.error == nil{
                    guard let data = response.data else { return }
                    guard let json = try? JSON(data : data) else{
                            print("Error")
                        return
                    }
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                    completion(true)
                }
                else{
                    completion(false)
                    debugPrint(response.error as Any)
                }
        }
    }

    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion : @escaping CompletionHandler) -> Void {
        let lowerCaseEmail = email.lowercased()
        
        let body : [String : Any] = [
            "name" : name,
            "email" : lowerCaseEmail,
            "avatarName" : avatarName,
            "avatarColor": avatarColor
        ]
        
        

        Alamofire.request(USER_ADD_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion : @escaping CompletionHandler) -> Void {
        print("\(USER_BY_EMAIL_URL)\(userEmail)")
        Alamofire.request("\(USER_BY_EMAIL_URL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func setUserInfo(data: Data) -> Void {
        
        guard let json = try? JSON(data : data) else{
            print("Error")
            return
        }
        print(json)
        let _id = json["_id"].stringValue
        let avatarColor = json["avatarColor"].stringValue
        
        let avatarName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
        
        
        UserDataService.instance.setUserData(id: _id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name)
    }
}
