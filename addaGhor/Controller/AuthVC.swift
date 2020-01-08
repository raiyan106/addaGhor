//
//  AuthVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 25/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import UIKit
import Firebase
class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("AuthVC Appeared")
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signInWithEmailButtonWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        loginVC?.modalPresentationStyle = .fullScreen
        present(loginVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func facebookSignInButtonWasPressed(_ sender: Any) {
    }
    
    @IBAction func googleSignInButtonWasPressed(_ sender: Any) {
    }
}
