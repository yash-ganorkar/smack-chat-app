//
//  ChatViewController.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/8/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    @IBOutlet weak var channelLabel: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        sendBtn.isEnabled = false
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel.id && AuthService.instance.isLoggedIn{
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                
                let indexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    if MessageService.instance.messages.count > 0 {
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
//        SocketService.instance.getChatMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//                let indexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                if MessageService.instance.messages.count > 0 {
//                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//                }
//            }
//        }
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.onLoginGetMessages()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector (ChatViewController.handleTap))
        
        view.addGestureRecognizer(tap)

    }
    
    
    @objc func handleTap() -> Void {
        view.endEditing(true)
    }
    func onLoginGetMessages() -> Void {
        MessageService.instance.getAllChannels { (success) in
            if MessageService.instance.channels.count > 0 {
                MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                self.updateWithChannel()
                self.getMessages()
            }
            else{
                self.channelLabel.text = "No channels yet!!"
            }
        }
        
    }
    
    func getMessages() -> Void {
        guard let channelId = MessageService.instance.selectedChannel.id else {
            return
        }
        MessageService.instance.fetchAllMessagesForChannel(channelId: channelId) { (success) in
            if success{
                self.tableView.reloadData()
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel.id else { return }
            
            var names = ""
            var noOfTypers = 0
            
            for(typingUser,channel) in typingUsers{
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    }
                    else {
                        names = "\(names), \(typingUser)"
                    }
                    noOfTypers += 1
                }
            }
            
            if noOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                
                if noOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUsersLbl.text = "\(names) \(verb) typing"
            }
            else{
                self.typingUsersLbl.text = ""
            }
        }
    }
    
    @objc func channelSelected (_ notif: Notification){
        updateWithChannel()
        getMessages()
    }
    
    func updateWithChannel() -> Void {
        let channelName = MessageService.instance.selectedChannel.title ?? ""
        channelLabel.text = "#\(channelName)"
        
    }
    
    @IBAction func sendMessageTouched(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            guard let channelId = MessageService.instance.selectedChannel.id else { return }
            
            guard let message = messageTextField.text, messageTextField.text != "" else { return }
            
            SocketService.instance.addNewMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name, channelId)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as? MessageViewCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel.id else { return }
        
        if messageTextField.text == ""{
            isTyping = false
            sendBtn.isEnabled = false
            SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name, channelId)
        }
        else{
            if isTyping == false{
                sendBtn.isEnabled = true
                SocketService.instance.manager.defaultSocket.emit("startType", UserDataService.instance.name, channelId)
            }
            
            isTyping = true
        }
    }
    
    
    
}
