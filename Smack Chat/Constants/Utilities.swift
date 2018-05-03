//
//  Utilities.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/10/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import Foundation

let USER_LOGGED_IN = "USER_LOGGED_IN"

//Constants
typealias CompletionHandler = (_ Success: Bool) -> ()
let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type" : "application/json; charset=utf-8"
    
]

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmaiL"

//URL
let BASE_URL = "https://smack-chat-app-yash.herokuapp.com/v1/"
let REGISTER_URL = "\(BASE_URL)account/register"
let LOGIN_URL = "\(BASE_URL)account/login"
let USER_ADD_URL = "\(BASE_URL)user/add"
let USER_BY_EMAIL_URL = "\(BASE_URL)user/byEmail/"
let FETCH_CHANNEL_URL = "\(BASE_URL)channel"
let FETCH_MESSAGES_URL = "\(BASE_URL)message/byChannel/"

let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")

