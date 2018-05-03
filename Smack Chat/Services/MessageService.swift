//
//  MessageService.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/12/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    
    var selectedChannel = Channel()
    var messages = [Message]()
    
    var unreadChannels = [String]()
    
    func getAllChannels(completion : @escaping CompletionHandler) -> Void {
        Alamofire.request(FETCH_CHANNEL_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else { return }
                guard let json = try? JSON(data : data).array else{
                    print("Error")
                    return
                }
                
                if !(json?.isEmpty)! {
                    for item in json! {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(title: name, description: description, id: id)
                        
                        self.channels.append(channel)
                        
                    }
                    //print(self.channels[0].title)
                    completion(true)
                }
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func fetchAllMessagesForChannel(channelId : String, completion : @escaping CompletionHandler) -> Void {
        
        Alamofire.request("\(FETCH_MESSAGES_URL)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                self.clearMessages()
                
                guard let data = response.data else { return }
                
                guard let json = try? JSON(data: data).array else {
                    print("Error")
                    return
                }
                
                
                
                if !(json?.isEmpty)! {
                    for item in json! {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue

                       
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                       // print("messageBody -> \(messageBody)")
                        self.messages.append(message)
                        
                    }
                    
                    completion(true)
                }
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
        
        
        
        
        
    }
    func clearMessages() -> Void {
        messages.removeAll()
    }
    func clearChannels() -> Void {
        channels.removeAll()
    }
    
}
