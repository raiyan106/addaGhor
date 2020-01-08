//
//  GroupVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 2/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import UIKit

class GroupVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var groups = [GroupMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DataService.instace.REF_GROUPS.observe(.value) { (groupSS) in
            DataService.instace.getAllGroupsForCurrentUser { (returnedGroup) in
                self.groups = returnedGroup
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func goToCreateGroupVC(_ sender: Any) {
        let createGroupVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
        createGroupVC.modalPresentationStyle = .fullScreen
        present(createGroupVC, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGroupFeedVC"{
            let destinationVC = segue.destination as! GroupFeedVC
            destinationVC.initGroupMessage(forGroupMessage: groups[tableView.indexPathForSelectedRow!.row])
            
        }
    }

    

}

extension GroupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else{ return UITableViewCell() }
        let cellForIndex = groups[indexPath.row]
        cell.configureCell(title: cellForIndex.title, description: cellForIndex.description, members: cellForIndex.totalMembers)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToGroupFeedVC", sender: self)
    }
    
    
}
