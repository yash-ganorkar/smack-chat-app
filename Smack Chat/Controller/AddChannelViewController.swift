//
//  AddChannelViewController.swift
//  Smack Chat
//
//  Created by Yash Ganorkar on 1/12/18.
//  Copyright © 2018 Yash Ganorkar. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController {

    @IBOutlet weak var channelNameText: CustomTextField!
    
    @IBOutlet weak var channelDescriptionText: CustomTextField!
    
    @IBOutlet weak var bgView: UIView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createBtnTouched(_ sender: Any) {
        guard let channelName = channelNameText.text, channelNameText.text != "" else {
            return
        }
        
        guard let channelDescription = channelDescriptionText.text, channelDescriptionText.text != "" else { return }
        
        SocketService.instance.addNewChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() -> Void {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelViewController.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
}
