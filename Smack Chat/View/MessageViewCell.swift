//
//  MessageViewCell.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/13/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message: Message) -> Void {
        messageLbl.text = message.message
        userNameLbl.text = message.userName
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        
        guard var isodate = message.timeStamp else {return}
        let end = isodate.index(isodate.endIndex, offsetBy: -5)
        isodate = isodate.substring(to: end)
        
        
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isodate.appending("Z"))
        
        let date = Date()
        let components = Calendar.current.dateComponents([.day], from: date, to: chatDate!)

       // print("Days -> \(components.day!)")
        
        var newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d, h:mm a"
        
        if components.day == 0 {
            newDateFormatter.dateFormat = "h:mm a"
            setDate(chatDate: chatDate, dateFormatter: newDateFormatter)
        }
        else {
           setDate(chatDate: chatDate, dateFormatter: newDateFormatter)
        }
    }
    
    func setDate(chatDate: Date?, dateFormatter: DateFormatter) -> Void {
        if let finalDate = chatDate{
            let finalDate = dateFormatter.string(from: finalDate)
            timeStampLbl.text = finalDate
        }
    }
}
