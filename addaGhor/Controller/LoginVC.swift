//
//  LoginVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 25/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailField: InsetTextField!
    
    @IBOutlet weak var passwordField: InsetTextField!
    
    @IBAction func signInButtonWasPressed(_ sender: Any) {
        if !emailField.text!.isEmpty && !passwordField.text!.isEmpty{
            AuthService.instance.loginUser(withEmail: emailField.text!, andPass: passwordField.text!) { (success, loginError) in
                if success{
                    print("Successfully logged in user")
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPass: self.passwordField.text!) { (success, registerError) in
                    if success{
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPass: self.passwordField.text!) { (success, nil) in
                            
                            print("Successfully registered user")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else{
                        print(String(describing: registerError?.localizedDescription))
                    }
                }
                
            }
        }
    }
    
    @IBAction func closeeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate{
    
}
