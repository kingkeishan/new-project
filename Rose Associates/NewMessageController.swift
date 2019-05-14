//
//  NewMessageController.swift
//  Rose Associates
//
//  Created by user145580 on 4/28/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    //instance of chatlog controller
    var ChatLog: ChatLogController?
    
    //arrays for tenants users
    var users = [Tenant2s]()
    
    //arrays for messages
    var Message = [chatMessages]()
    
    //dictionary for chatmessages(a filter for message)
    var messageDictionary = [String : chatMessages]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Message.removeAll()
        //messageDictionary.removeAll()
        
        
       
       // table with no seperator lines
        tableView.separatorStyle = .none
        
        //table row height
        tableView.rowHeight = 100
    
        //observing messages func
        obsereUserMessage()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
       

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = Message[indexPath.row]
        
        let chatparthnerid = childPartherID(fromid: message.fromid!, toid: message.toid!)
        Database.database().reference().child("usermessages").child(uid).child(chatparthnerid).removeValue { (error, reference) in
            if error != nil {
                print(error)
            }else {
                self.messageDictionary.removeValue(forKey: chatparthnerid)
                self.attemptoreloadtable()
                
            }
        }
        
        
    }
    
//table view number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Message.count
    }
    
    //when tableViewRow Is Selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //converting message from Message array(of chatmessages)
        let message = Message[indexPath.row]
        
        //chatpartherid = if currentuser uid is fromid return toid, else return fromid
        let chatpartherid = childPartherID(fromid: message.fromid!, toid: message.toid!)
        
        //reference to database with childed Usersid
        let ref = Database.database().reference().child("Users").child(chatpartherid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //converting dictionary to snapshot
            let dictionary = snapshot.value as? [String : Any]
            
            //going though dictionary and checking if user is tenant or staff
            for (key,value) in dictionary! {
                
                //if user is tenant, store value in user varible
                if key == "Unit" {
            let user = Tenant2s(LastName: dictionary!["LastName"] as! String, FirstName: dictionary!["FirstName"] as! String, Language: dictionary!["Language"] as! String, ProfilePic: dictionary!["ProfilePic"] as! String, Unit: dictionary!["Unit"] as! String, Bio: dictionary!["Bio"] as! String, Birthday: dictionary!["Birthday"] as! String, UserType: dictionary!["UserType"] as! String, UserID: chatpartherid)
            
                    //reference to chatcontroller
            self.ChatLog = ChatLogController()
                    
                    //sending user varible to chatcontroller
            self.ChatLog?.user = user
            
                    //presenting chat log with user imfo that was selected
                    self.navigationController?.pushViewController(self.ChatLog!, animated: true)}
                
                //if user is staff, store value in staff varible
                if key == "Position" {
                    let staff = Staff2s(LastName: dictionary!["LastName"] as! String, FirstName: dictionary!["FirstName"] as! String, Language: dictionary!["Language"] as! String, ProfilePic: dictionary!["ProfilePic"] as! String, Position: dictionary!["Position"] as! String, Bio: dictionary!["Bio"] as! String, Birthday: dictionary!["Birthday"] as! String, UserType: dictionary!["UserType"] as! String, UserID: chatpartherid)
                    
                    //reference to chatlogcontroller
                    self.ChatLog = ChatLogController()
                    
                    //sending user varible to chatcontroller
                    self.ChatLog?.staff = staff
                    
                    //presenting chat log with staff info that was selected
                    self.navigationController?.pushViewController(self.ChatLog!, animated: true)
                    
                }}
            
        }, withCancel: nil)
        
    
        
        
    }
    
    //confuguring cell for row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell equal my custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewMessageCell
        let chatpartnerid: String?
        
        //converting message array of chat messages to varible per row
        let Mess = Message[indexPath.row]
        
        //confuguring chatparnerid
        if Mess.fromid == Auth.auth().currentUser?.uid {
            chatpartnerid = Mess.toid
        }else {
            chatpartnerid = Mess.fromid
        }
        //assigning the to id from chatmessage to toid
        if let id = chatpartnerid {
            
            //database reference to users who recevie the message
            let ref = Database.database().reference().child("Users").child(chatpartnerid!)
            
            //observing the reference
            ref.observe(.value, with: { (snapshot) in
                
                //assinging snapshot to dictionary
                let dictionary = snapshot.value as! [String : Any]
                
                //assinging dictionary values to cell per row
                let FirstName = dictionary["FirstName"] as! String
                let LastName = dictionary["LastName"] as! String
                cell.NameLabel.text = FirstName + " " + LastName
                
                //assinging image to cell image
                cell.CelIImage.loadImageUsingCache(urlString: dictionary["ProfilePic"] as! String)
                
            }, withCancel: nil)
        }
        
        //converting timestamp back into date
        let timestamp = Date(timeIntervalSince1970: (Mess.timestamp?.doubleValue)!)
        
        //making a date formatter
        let dateFormat = DateFormatter()
        
        //setting the date formatter
        dateFormat.dateFormat = "hh:mm:ss a"
        
        //putting the time stamp in the date formatter
        cell.TimeStamp.text = dateFormat.string(from: timestamp)
        cell.TextLabel.text = Mess.text
        
        
        
        return cell
        
    }
    //if current user id is fromid return toid, if toid return from id
    func childPartherID(fromid: String, toid: String) -> String {
        return fromid == Auth.auth().currentUser?.uid ? toid : fromid
    }
    
    //observe message func
    func obsereUserMessage(){
        
        //assinging current user id to uid
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        //getting reference to database usermessages of user
        let ref = Database.database().reference().child("usermessages").child(uid)
        
        //observe all messages that user send and receve
        ref.observe(.childAdded, with: { (snapshot) in
            
            //the second user id envolve in the message
            let userid = snapshot.key
            
            //refernce to the message id
            Database.database().reference().child("usermessages").child(uid).child(userid).observe(.childAdded, with: { (snapshot) in
                
                //message id reference
                let messageid = snapshot.key
                
                
                //getting reference to user messages
                let messageref = Database.database().reference().child("chatmessages").child(messageid)
                
                //obsevere all messages from and to user
                messageref.observeSingleEvent(of: .value, with: { (snapshot2) in
                    
                    
                //putting the message in a dictionary
                   var dictionary = snapshot2.value as! [String : Any]
           
                    //putting dictionary into item
                    var message = chatMessages(dictionary: dictionary)
                    
                    
                    //if currentuser id == fromid return toid else return from id
                    let chatPartherID = self.childPartherID(fromid: message.fromid!, toid: message.toid!)
                    
                    //filtering messages to make make only new messages show
                    self.messageDictionary[chatPartherID] = message
                    
                    
                    self.attemptoreloadtable()
                    
                    
                    })
                
                    
                    
                    
                }, withCancel: nil)
                
            }, withCancel: nil)
           
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messageDictionary.removeValue(forKey: snapshot.key)
            self.attemptoreloadtable()
        }, withCancel: nil)
            
            
        
    }
    
    var timer: Timer?
    func attemptoreloadtable () {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handlereloadtable), userInfo: nil, repeats: false)
    }
    @objc func handlereloadtable(){
        //appending only new messages
        self.Message = Array(self.messageDictionary.values)
        //sorting messages by time stamp
        self.Message.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.intValue > message2.timestamp!.intValue    })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
}
}
