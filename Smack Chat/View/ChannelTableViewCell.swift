//
//  ChannelTableViewCell.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/12/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var channelLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
            channelLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        }
        else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel : Channel) -> Void {
        let title = channel.title ?? ""
        channelLbl.text = "#\(title)"
        
        channelLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                channelLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }

}
