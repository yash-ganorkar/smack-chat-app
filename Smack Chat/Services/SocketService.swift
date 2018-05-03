//
//  SocketService.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/12/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    

    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    func establishConnection() -> Void {
        manager.defaultSocket.connect()
        print("Socket Connected...")
    }
    func closeConnection() -> Void {
        manager.defaultSocket.disconnect()
        print("Socket disconnected...")

    }
    
    func addNewChannel(channelName: String, channelDescription: String, completion : @escaping CompletionHandler) -> Void {
        manager.defaultSocket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) -> Void {
        manager.defaultSocket.on("channelCreated") { (dataArray, ack) in
            
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(title: channelName, description: channelDescription, id: channelId)
            
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addNewMessage(messageBody: String, userId: String, channelId: String, completion : @escaping CompletionHandler) -> Void {
        
        let user = UserDataService.instance
        
        manager.defaultSocket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
        
    }
    
    func getChatMessage(completion : @escaping (_ newMessage: Message) -> Void) -> Void {
        manager.defaultSocket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            completion(newMessage)
        }
        
        
    }
    
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers : [String : String]) -> Void) -> Void {
        manager.defaultSocket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String : String] else { return }
            
            completionHandler(typingUsers)
        }
    }
    
    
}
