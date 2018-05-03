//
//  CircleView.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/11/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() -> Void {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
