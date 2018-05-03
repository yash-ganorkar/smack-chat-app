//
//  GradientView.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/8/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

//added to notify that this class needs to render inside storyboard
//CG stands for CoreGraphics
@IBDesignable
class GradientView: UIView {
    //variable that can be changed inside storyboard
    @IBInspectable var topColor : UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1){
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor : UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1){
        didSet {
            self.setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        let gradientLayer  =  CAGradientLayer()
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
