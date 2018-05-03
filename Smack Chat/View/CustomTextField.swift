//
//  CustomTextField.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/9/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2456656678)
        layer.cornerRadius = 5.0
        textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        
        if placeholder == nil{
            placeholder = " "
        }
        
        let place = NSAttributedString(string: placeholder!, attributes: [.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        
        attributedPlaceholder = place
        
        
    }
}
