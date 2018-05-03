//
//  ChannelViewController.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/8/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var userImage: CircleView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        setupView()

        SocketService.instance.getChannel(completion: { (success) in
            if success{
                self.tableView.reloadData()
            }
        })

        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel.id && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelTableViewCell", for: indexPath) as? ChannelTableViewCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }
        else{
        return UITableViewCell()
        }
    }
    
    @IBAction func signOutBtnTouched(_ sender: Any) {
        UserDataService.instance.logoutUser()
        performSegue(withIdentifier: "LoginViewController", sender: self)
    }
    
    
    @IBAction func addChannelBtnTouched(_ sender: Any) {
        let addChannel = AddChannelViewController()
        addChannel.modalPresentationStyle = .custom
        present(addChannel, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
    
    func setupView() -> Void {
                    nameBtn.setTitle(UserDataService.instance.name, for: .normal)
                    userImage.image = UIImage(named: UserDataService.instance.avatarName)
                    userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
    }
}
