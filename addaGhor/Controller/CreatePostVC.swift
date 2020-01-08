//
//  CreatePostVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 27/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import UIKit
import Firebase


class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        sendButton.bindToKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        emailLabel.text = Auth.auth().currentUser?.email
        print("Mevc appeared with \(String(describing: Auth.auth().currentUser?.email))")
     
    }
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        if textView.text != "" && textView.text != "Say something here..."{
            sendButton.isEnabled = false
            DataService.instace.uploadPost(withMessage: textView.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: nil) { (success) in
                if success{
                    self.sendButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    self.sendButton.isEnabled = true
                    print("Error found\n")
                }
            }
        }
        
        
        
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreatePostVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
