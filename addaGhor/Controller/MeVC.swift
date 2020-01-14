//
//  MeVC.swift
//  addaGhor
//
//  Created by Raiyan Khan on 27/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//
import Firebase
import UIKit
import FirebaseStorage

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
        profileImage.makeRounded()
        emailLabbel.text = Auth.auth().currentUser?.email
        DataService.instace.getCurrentUserFeed { (returnedMsg) in
            self.ownFeedArray = returnedMsg.reversed()
            self.tableView.reloadData()
        }
        DataService.instace.getUserImageForMeVC { (img) in
            self.profileImage.image = img
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
    
    @IBAction func addProfileImg(_ sender: Any) {
        uploadPhoto()
        
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

extension MeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func uploadPhoto(){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        imgPicker.modalPresentationStyle = .fullScreen
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
//        print(info)
        profileImage.image = img
//        upload profile image in Firestore
        DataService.instace.uploadUserImage(forUserId: Auth.auth().currentUser!.uid, uploadImg: img) { (success, err) in
            if success {
                print("Successful upload")
            }
            else{
                print("sth went wrong")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
