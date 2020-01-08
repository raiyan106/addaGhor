//
//  AuthService.swift
//  addaGhor
//
//  Created by Raiyan Khan on 25/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPass pass: String, userCreationDone: @escaping (_ status: Bool, _ error: Error?)-> Void){
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationDone(false, error)
                return
            }
            let userData = ["provider": user.providerID, "email":user.email]
            DataService.instace.createDBUser(uid: user.uid, userData: userData as! Dictionary<String, String>)
            userCreationDone(true,nil)
        }
    }
    
    func loginUser(withEmail email: String, andPass pass: String, loginDone: @escaping (_ status: Bool, _ error: Error?)-> Void){
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            guard let _ = authResult?.user else{
                loginDone(false, error)
                return
            }
            loginDone(true,nil)
        }
        
    }
    
}
