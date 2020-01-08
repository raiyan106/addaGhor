//
//  CreateGroupVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 2/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var newPeopleList: InsetTextField!
    @IBOutlet weak var addedUsersList: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    var emailArray = [String]()
    var chosenUsers = [String]()
    
    var idOfUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        newPeopleList.delegate = self
        newPeopleList.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if chosenUsers.count==0{
            doneBtn.isHidden = true
        }
    }
    
    @objc func textFieldDidChange(){
        if newPeopleList.text == ""{
            emailArray = []
            self.tableView.reloadData()
        } else{
            DataService.instace.getEmail(forSearchQuery: newPeopleList.text!) { (returnedArray) in
                self.emailArray = returnedArray
                self.tableView.reloadData()
            }
        }
    }
    

    @IBAction func closeNewGroupVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneBtnWasPressed(_ sender: Any) {
        if !titleTextField.text!.isEmpty && !descriptionTextField.text!.isEmpty{
            DataService.instace.getIds(forUserNames: chosenUsers) { (returnedVals) in
                var tempArr = returnedVals
                tempArr.append((Auth.auth().currentUser!.uid))
                
                DataService.instace.createGroup(withTitle: self.titleTextField.text!, andDescription: self.descriptionTextField.text!, forUserIds: tempArr) { (groupCreation) in
                    if groupCreation{
                        print("Group creation succesfull");
                        self.dismiss(animated: true, completion: nil);
                    }
                    else{
                        print("Could not create Group");
                    }
                }
            }
        }
    }
    
}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {
            return UITableViewCell()
        }
        if chosenUsers.contains(emailArray[indexPath.row]){
            cell.configureCell(profileImg: UIImage(named: "defaultProfileImage")!, email: emailArray[indexPath.row], isSelected: true)
        } else{
        cell.configureCell(profileImg: UIImage(named: "defaultProfileImage")!, email: emailArray[indexPath.row], isSelected: false)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if cell.checkImg.isHidden{
            cell.checkImg.isHidden = false
        }
        else{
            cell.checkImg.isHidden = true
        }
        if !chosenUsers.contains(cell.emailLabel.text!){
            chosenUsers.append(cell.emailLabel.text!)
            addedUsersList.text = chosenUsers.joined(separator: ", ")
            doneBtn.isHidden = false
        } else{
            chosenUsers = chosenUsers.filter({$0 != cell.emailLabel.text!})
            if chosenUsers.count>=1 {
                addedUsersList.text = chosenUsers.joined(separator: ", ")
            }
            else{
                addedUsersList.text = "..."
                doneBtn.isHidden = true
            }
        }
        
    }
    
    
}

extension CreateGroupVC: UITextFieldDelegate{
    
}
