//
//  DataService.swift
//  addaGhor
//
//  Created by Raiyan Khan on 23/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService{
    static let instace = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    private var _STORAGE_REF_USER_IMAGES = STORAGE_BASE.child("images")
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    var REF_GROUPS: DatabaseReference{
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference{
        return _REF_FEED
    }
    var REF_USER_IMAGES: StorageReference{
        return _STORAGE_REF_USER_IMAGES
    }
    
    func uploadUserImage(forUserId uid: String, uploadImg img: UIImage?, handler: @escaping (_ success: Bool, _ error: Error?)->Void){
        guard let uploadData = img?.jpegData(compressionQuality: 0.2) else {return}
        
        let storageRef = REF_USER_IMAGES.child("profileImgOf-\(uid).jpg")
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if error != nil{
                handler(false,nil)
            }
            else{
                storageRef.downloadURL { (url, err) in
                    guard let url = url else {return}
                    self.REF_USERS.child(uid).updateChildValues(["profileImgURL" : String(describing: url)])
                    
                    handler(true, error)
                }
            }
        }
    }
    
    func getUserImageForMeVC(handler: @escaping (_ img: UIImage)->Void){
        REF_USERS.observeSingleEvent(of: .value) { (userSS) in
            guard let userSS = userSS.children.allObjects as? [DataSnapshot] else{return}
            for user in userSS{
                if user.key == Auth.auth().currentUser?.uid{
                    guard let imgURL = user.childSnapshot(forPath: "profileImgURL").value as? String else{
                        
                        handler(UIImage(named: "defaultProfileImage")!)
                        return
                    }
                    let url = NSURL(string: imgURL)
                    URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
                        if error != nil{
                            print("image not found")
                            return
                        }
                        DispatchQueue.main.async {
                            if let img = UIImage(data: data!){
                                handler(img)
                            } else{
                                print("nil data found")
                            }
                        }
                        
                            
                        
                    }.resume()
                    
                    return
                }
            }
        }
    }
    
    
    func getCurrentUserFeed(handler: @escaping (_ msg: [String])->Void){
        var msgArray = [String]()
        REF_FEED.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let currentusershot = dataSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for feeds in currentusershot{
                let id = feeds.childSnapshot(forPath: "senderID").value as? String
                if Auth.auth().currentUser?.uid == id{
                    let msg = feeds.childSnapshot(forPath: "content").value as! String
                    msgArray.append(msg)
                }
            }
            handler(msgArray)
        }
        
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String)->Void){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else{return}
            for users in userSnapShot{
                if users.key == uid{
                    handler(users.childSnapshot(forPath: "email").value as! String)
                    break
                }
            }
            
        }
    }
    
    func createDBUser(uid:String, userData: Dictionary<String,Any>){
        print("CreateDBUser called succesfully")
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(withMessage msg: String, forUID uid: String, withGroupKey groupKey: String?,sendComplete: @escaping (_ status: Bool)-> Void){
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content":msg, "senderID":uid, "time":CurrentTime.time.now()])
            sendComplete(true)
        } else{
            REF_FEED.childByAutoId().updateChildValues(["content" : msg, "senderID": uid, "time": CurrentTime.time.now()])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message])->Void){
        var msgArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMsgSnapshot) in
            guard let feedMsgSnapshot = feedMsgSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for msg in feedMsgSnapshot{
                let content = msg.childSnapshot(forPath: "content").value as! String
                let senderid = msg.childSnapshot(forPath: "senderID").value as! String
                let time = msg.childSnapshot(forPath: "time").value as! String
                let message = Message(content: content, senderId: senderid, time: time)
                msgArray.append(message)
            }
            
            handler(msgArray)
        }
    }
    
    func getAllMessagesForGroup(forGroup group: GroupMessage, handler: @escaping (_ messages: [Message])->Void){
        var msgArray = [Message]()
        REF_GROUPS.child(group.groupKey).child("messages").observeSingleEvent(of: .value) { (messageSS) in
            guard let messageSS = messageSS.children.allObjects as? [DataSnapshot] else {return}
            for msg in messageSS{
                let content = msg.childSnapshot(forPath: "content").value as! String
                let senderID = msg.childSnapshot(forPath: "senderID").value as! String
                let time = msg.childSnapshot(forPath: "time").value as! String
                let msg = Message(content: content, senderId: senderID, time: time)
                msgArray.append(msg)
            }
            handler(msgArray)
        }
        
    }
    
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray:[String])->Void){
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) && email != Auth.auth().currentUser?.email{
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUserNames usernames: [String], handler: @escaping(_ uidArrays: [String])->Void){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var keyArray = [String]()
            guard let usersnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for userss in usersnapshot{
                let email = userss.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email){
                    keyArray.append(userss.key)
                }
            }
            handler(keyArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds users: [String], handler: @escaping (_ groupCreation: Bool)->Void){
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": users, "totalMembers": users.count])
        handler(true)
    }
    
    func getAllGroupsForCurrentUser(_ handler: @escaping (_ groupArray: [GroupMessage])->Void){
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            var groupsToShow = [GroupMessage]()
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot{
                let members = group.childSnapshot(forPath: "members").value as! [String]
                if (members.contains(Auth.auth().currentUser!.uid)){
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let desc = group.childSnapshot(forPath: "description").value as! String
                    let totalMembers = group.childSnapshot(forPath: "totalMembers").value as! Int
                    let newGroup = GroupMessage(title: title, description: desc, members: members, groupKey: group.key, totalMembers: totalMembers)
                    groupsToShow.append(newGroup)
                }
            }
            handler(groupsToShow)
        }
    }
    
    func getUserEmail(forGroup group: GroupMessage, handler: @escaping (_ emails: [String])->Void){
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSS) in
            guard let userSS = userSS.children.allObjects as? [DataSnapshot] else { return }
            for user in userSS{
                if group.members.contains(user.key){
                    emailArray.append(user.childSnapshot(forPath: "email").value as! String)
                }
            }
            handler(emailArray)
        }
    }
    
}
