//
//  AvatarCollectionViewCell.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/11/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(index: Int, type: AvatarType) -> Void {
        if type == AvatarType.dark {
            avatarImage.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        else{
            avatarImage.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
    
    func setupView() -> Void {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    
    
}
