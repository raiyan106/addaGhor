//
//  FeedVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 22/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.reloadData()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instace.REF_FEED.observe(.value) { (snapshot) in
            DataService.instace.getAllFeedMessages { (messagesArrReturned) in
                self.messageArray = messagesArrReturned.reversed()
                self.tableView.reloadData()

            }
        }

    }

    
    
    @IBAction func newPostBtn(_ sender: Any) {
        let cpv = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostVCID") as! CreatePostVC
        cpv.modalPresentationStyle = .fullScreen
        present(cpv, animated: true, completion: nil)
    }

    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else{
            return UITableViewCell() }
        let image = UIImage(named: "defaultProfileImage")
        let message = messageArray[indexPath.row]
        DataService.instace.getUsername(forUID: message.senderId) { (returnUsername) in
            cell.configureCell(profileImage: image!, email: returnUsername, content: message.content, time: message.time)
        }
        
        return cell
    }
    
    
}

