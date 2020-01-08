//
//  MeVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 27/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//
import Firebase
import UIKit

class MeVC: UIViewController {
    var ownFeedArray = [String]()

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var emailLabbel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        emailLabbel.text = Auth.auth().currentUser?.email
        DataService.instace.getCurrentUserFeed { (returnedMsg) in
            self.ownFeedArray = returnedMsg.reversed()
            self.tableView.reloadData()
        }
        
        
     
    }

    @IBAction func signOutButtonPressed(_ sender: Any) {
        let logoutPop = UIAlertController(title: "Logout", message: "Want to log out?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Yes", style: .destructive) { (btnPressed) in
            do{
                try Auth.auth().signOut()
                print("Successfully signed out")
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                authVC.modalPresentationStyle = .fullScreen
                self.present(authVC, animated: true, completion: nil)
            }
            catch{
                print("Logout Unsuccesfully")
            }
        }
        
        logoutPop.addAction(action)
        present(logoutPop, animated: true, completion: nil)
    }
    
    
    
}

extension MeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ownFeedArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ownFeedCell") else {return UITableViewCell()}
        cell.textLabel?.text = ownFeedArray[indexPath.row]
        return cell
    }


}
