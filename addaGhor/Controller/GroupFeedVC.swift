//
//  GroupFeedVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 7/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var msgTextField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var group: GroupMessage?
    var allMembers = [String]()
    var allMessages = [Message]()
    
    func initGroupMessage(forGroupMessage g: GroupMessage){
        self.group = g
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        sendBtnView.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        groupTitleLabel.text = group?.title
        
        DataService.instace.getUserEmail(forGroup: group!) { (returnedEmails) in
            self.allMembers = returnedEmails
            //cprint(self.allMembers.joined(separator: ","))
        }
        DataService.instace.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instace.getAllMessagesForGroup(forGroup: self.group!) { (returnedMsg) in
                self.allMessages = returnedMsg
                self.tableView.reloadData()
                
                if self.allMessages.count > 0{
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.allMessages.count-1, section: 0), at: .none, animated: true)
                }
                
            }
        }
        

        
    }
    
    
    @IBAction func viewMembersBtnWasPressed(_ sender: Any) {
        let members = allMembers.joined(separator: ",\n")
        let controller = UIAlertController(title: "All members", message: members, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(action)
        present(controller, animated: true)
        
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if msgTextField.text != ""{
            msgTextField.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instace.uploadPost(withMessage: msgTextField.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.groupKey) { (success) in
                if success{
                    self.msgTextField.text = ""
                    self.msgTextField.isEnabled = true
                    self.sendBtn.isEnabled = true
                    //self.tableView.reloadData()
                    print("message sent success")
                }
                else{
                    self.sendBtn.isEnabled = true
                    print("Error")
                }
            }
        }
    }
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupFeedCell") as? GroupFeedCell else {return UITableViewCell()}
        let img = UIImage(named: "defaultProfileImage")
        let msg = allMessages[indexPath.row]
        
        DataService.instace.getUsername(forUID: msg.senderId) { (returnedUsername) in
            cell.configure(profileImg: img!, userEmail: returnedUsername, timeOfMsg: msg.time, msgContent: msg.content)
        }
        
        return cell
    }
    
    
}
