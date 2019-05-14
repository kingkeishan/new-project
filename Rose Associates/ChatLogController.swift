//
//  ChatLogController.swift
//  Rose Associates
//
//  Created by user145580 on 4/28/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation



class ChatLogController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
    //tenant of staff user id
    var userorstaffid = [String]()
    
    //array for chatmessage
    var MessageArray = [chatMessages]()
    
    //toid refernce
    var toid: String?
    
  
    
    
    @IBOutlet weak var textfield: UITextField!
    
    

    

    //cell id for register cell
    let cellid = "cell"
    
    
  
    //tenant users
    var user : Tenant2s? {
        didSet {
            //changing navigation bar title when var user gets assign
            navigationItem.title = (user!.FirstName)! + " " + (user!.LastName)!
            toid = (user?.UserID)!
            observeMessages()
            
        }
    }
    //staff users
    var staff : Staff2s? {
        didSet {
            //set navigationbar title when var staff gets assign
            navigationItem.title = (staff!.FirstName)! + " " + (staff!.LastName)!
            toid = (staff?.UserID)!
            observeMessages()
        }
    }
//collection view instance
 let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
    
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    var Send: UIButton?
    //camera picture to send pics
    var camera: UIImageView?
    var bottomContainerView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //confuguring camera picture
        camera = UIImageView()
        camera?.image = UIImage(named: "imagePickder.png")?.withRenderingMode(.alwaysTemplate)
        camera?.tintColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
    
        camera?.translatesAutoresizingMaskIntoConstraints = false
        camera?.isUserInteractionEnabled = true
        
        //adding gesture recognizer to camera
        camera?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickForImage)))
        
        
        
       textfield = UITextField()

       
     
      //confuguring collection view
        collection.register(Chatcell.self, forCellWithReuseIdentifier: cellid)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        collection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collection.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
       view.addSubview(collection)
        
        
        
        
        //view for send message
        bottomContainerView = UIView()
        bottomContainerView!.backgroundColor = .white
        bottomContainerView!.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomContainerView!)
        
        
        bottomContainerView!.addSubview(camera!)
        
        //camera picture anchor constraints
        camera?.leftAnchor.constraint(equalTo: bottomContainerView!.leftAnchor).isActive = true
        camera?.centerYAnchor.constraint(equalTo: bottomContainerView!.centerYAnchor).isActive = true
        camera?.widthAnchor.constraint(equalToConstant: 44).isActive = true
        camera?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        //collectionview constraints
        collection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //view for send message constraints
        bottomContainerView!.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomContainerView!.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerViewBottomAnchor = bottomContainerView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor!.isActive = true
        
        //textfield confuguration
         textfield.borderStyle = . none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Enter message..."
        textfield.delegate = self
                bottomContainerView!.addSubview(textfield)
        
        //send button
        Send = UIButton(type: .system)
        Send?.setTitle("Send", for: .normal)
        Send!.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        Send!.isEnabled = false
        
        Send!.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView!.addSubview(Send!)
        
        //textfield constraints
        textfield.leftAnchor.constraint(equalTo: camera!.rightAnchor, constant: 8).isActive = true
        textfield.rightAnchor.constraint(equalTo: Send!.leftAnchor).isActive = true
        textfield.heightAnchor.constraint(equalTo: bottomContainerView!.heightAnchor).isActive = true
        textfield.centerYAnchor.constraint(equalTo: bottomContainerView!.centerYAnchor).isActive = true
        
       
        //send button confuguration
        Send!.rightAnchor.constraint(equalTo: bottomContainerView!.rightAnchor).isActive = true
        Send!.heightAnchor.constraint(equalTo: bottomContainerView!.heightAnchor).isActive = true
       Send!.widthAnchor.constraint(equalToConstant: 80).isActive = true
        Send!.centerYAnchor.constraint(equalTo: bottomContainerView!.centerYAnchor).isActive = true
        
        
        //sperator line on top send button message view
        let seperatorview = UIView()
        seperatorview.translatesAutoresizingMaskIntoConstraints = false
        seperatorview.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        bottomContainerView!.addSubview(seperatorview)
        
        //seperator line constraints
        seperatorview.widthAnchor.constraint(equalTo: bottomContainerView!.widthAnchor).isActive = true
        seperatorview.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorview.topAnchor.constraint(equalTo: bottomContainerView!.topAnchor).isActive = true
        seperatorview.leftAnchor.constraint(equalTo: bottomContainerView!.leftAnchor).isActive = true
        
       
        
     //keyboard observers
       setupKeyBooardObservers()
        

            }
    
    //when the camer get clicked
    @objc func clickForImage(){
        
        //creating a instance for image picker
        let imagePicker = UIImagePickerController()
        
        //image picker delegate
        imagePicker.delegate = self
        
        //image picker alowed editing
        imagePicker.allowsEditing = true
        
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        //present image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    //clicked cancel when selecting image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //clicked a image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            handlevideoselectedforurl(urlfromcamera: videoUrl)
            
       
        }else {
            //if we selected a image!!
            
            //selected image varible
            var SelectedImageFromPicker: UIImage?
            
            //getting the edited image if edited
            if let editedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                SelectedImageFromPicker = editedimage
            } else {
                
                //getting the original image if original
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    SelectedImageFromPicker = image }
            }
            // making varible for selected image
            if let selectedImage = SelectedImageFromPicker {
                
                //upload selected image to firebase storage
                uploadtofirebasestorage(image: selectedImage) { (imageurl) in
                    //function to reteve stored image and width and height
                    self.sendimagetodatabasewithimageurl(imageUrl: imageurl, image: selectedImage )
                }
            }
            
        }
        
    
       //dismiss afther image is picked
        dismiss(animated: true, completion: nil)
        
        //keyboard stays up after image is picked
        textfield.becomeFirstResponder()
        
        
        
       
        
    }
    
    func handlevideoselectedforurl(urlfromcamera: URL){
        
        let filename = NSUUID().uuidString + ".mov"
        let storagereference = Storage.storage().reference().child("Groupmessage-movies").child(filename)
        
        let storageputfile = storagereference.putFile(from: urlfromcamera, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error)
                
            }else {
                
                storagereference.downloadURL(completion: { (url, error) in
                    if let videourl = url?.absoluteString {
                        
                        if let thumbnailImage = self.thumbnailImageForVideo(videourl2: urlfromcamera){
                            
                            
                            
                            self.uploadtofirebasestorage(image: thumbnailImage, completion: { (imageurl2) in
                                
                            
                            //get user id if staff is nil
                            if self.staff == nil {
                                self.userorstaffid.removeAll()
                                //apply tenant id if staff is nil
                                let userid = self.user!.UserID
                                self.userorstaffid.append(userid!)
                            }
                            
                            // get staff id if user if nil
                            if self.user == nil {
                                self.userorstaffid.removeAll()
                                //if tenant user is nil apply staff id
                                let userid = self.staff!.UserID
                                self.userorstaffid.append(userid!)
                            }
                            
                            let fromid = Auth.auth().currentUser?.uid
                            let timeStamp = NSDate().timeIntervalSince1970 as NSNumber
                                let properties = ["imageurl" : imageurl2, "videourl" : videourl, "userid" : self.userorstaffid[0], "fromid" : fromid, "timestamp" : timeStamp, "imagewidth" : thumbnailImage.size.width , "imageheight" : thumbnailImage.size.height] as [String : Any]
                            self.sendVideoAsMessage(values: properties)
                                
                            })
                        }
                       
                       
                        
                    }
                })
                
                
            }
        }
        storageputfile.observe(.progress) { (snapshot) in
            self.navigationItem.title = "Uploading video.."
            
            storageputfile.observe(.success, handler: { (snapshot) in
                if self.staff == nil {
                    self.navigationItem.title = (self.user!.FirstName)! + " " + (self.user!.LastName)!
                    
                }
                if self.user == nil {
                    self.navigationItem.title = (self.staff!.FirstName)! + " " + (self.staff!.LastName)!
                    
                }
            })
        }
        
    }
    
    //up load to firebase storage function
    func uploadtofirebasestorage(image: UIImage , completion: @escaping (_ imageurl: String) -> ()){
        
        //making a uuid for images geting stored
        let imagename = NSUUID().uuidString
        
        //reference to storage database
        let ref = Storage.storage().reference().child("message-images").child(imagename)
        
        //compressing image and converting in data
        let uploaddata = image.jpegData(compressionQuality: 0.1)
        
        //storing image in storage
        ref.putData(uploaddata!, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Image did not upload", error)
            }else {
                
                //URL to stored image
                ref.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error)
                    }else{
                        
                        //storing URL to image that was put in storing in varible
                        if let imageURL = url?.absoluteString {
                            completion(imageURL)
                        
                        }
                    }
                })
            }
        }
        
    }
    
    
    func thumbnailImageForVideo(videourl2 : URL) -> UIImage? {
        let asset = AVAsset(url: videourl2)
        let assestGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailImage = try assestGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        }catch {
            
            print(error)
        }
     return nil
    }
    
    func sendimagetodatabasewithimageurl(imageUrl: String, image: UIImage){
        
        //creating reference in database for messages
        let Childref =  Database.database().reference().child("chatmessages").childByAutoId()
        
        //get user id if staff is nil
        if staff == nil {
            userorstaffid.removeAll()
            //apply tenant id if staff is nil
            let userid = user!.UserID
            userorstaffid.append(userid!)
        }
        
        // get staff id if user if nil
        if user == nil {
            userorstaffid.removeAll()
            //if tenant user is nil apply staff id
            let userid = staff!.UserID
            userorstaffid.append(userid!)
        }
        //current user id
        let fromid = Auth.auth().currentUser!.uid
        
        //setting todays date as time stamp with time interval from 1970
        let timeStamp = NSDate().timeIntervalSince1970 as NSNumber
        
        //values to store in reference
        let values = ["imageurl" : imageUrl, "userid" : userorstaffid[0], "fromid" : fromid, "timestamp" : timeStamp, "imagewidth" : image.size.width , "imageheight" : image.size.height] as [String : Any]
        
        //empty text when send is clicked
        textfield.text = ""
        
        //send in the values to  database
        Childref.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
            }
            
            //database reference to usermessages with current user id
            let userMessageRef = Database.database().reference().child("usermessages").child(fromid).child(self.userorstaffid[0])
            
            //the messageid from current user
            let messageid = ref.key!
            
            //create message for user under usermessages in database
            userMessageRef.updateChildValues([messageid : 1]) { (error, Reference) in
                
            }
            
            
            
            
            
            
            
            //create reference in data base for the TO user can receve message uunder his id also
            let toUserMessage = Database.database().reference().child("usermessages").child(self.userorstaffid[0]).child(fromid)
            toUserMessage.updateChildValues([messageid : 1])
        }    }
    
    
    
    func sendVideoAsMessage(values: [String : Any]) {
        
        
        //creating reference in database for messages
        let Childref =  Database.database().reference().child("chatmessages").childByAutoId()
        
    
        
        //current user id
        let fromid = Auth.auth().currentUser!.uid
        
        //setting todays date as time stamp with time interval from 1970
        let timeStamp = NSDate().timeIntervalSince1970 as NSNumber
        
        
        //send in the values to  database
        Childref.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
            }
            
            //database reference to usermessages with current user id
            let userMessageRef = Database.database().reference().child("usermessages").child(fromid).child(self.userorstaffid[0])
            
            //the messageid from current user
            let messageid = ref.key!
            
            //create message for user under usermessages in database
            userMessageRef.updateChildValues([messageid : 1]) { (error, Reference) in
                
            }
            
            
            
            
            
            
            
            //create reference in data base for the TO user can receve message uunder his id also
            let toUserMessage = Database.database().reference().child("usermessages").child(self.userorstaffid[0]).child(fromid)
            toUserMessage.updateChildValues([messageid : 1])
        }
    }
    
    
    //keyboard observers function
    func setupKeyBooardObservers (){
        
        //when keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(keybooardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //when keyboard hides
        NotificationCenter.default.addObserver(self, selector: #selector(keybooardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    
    @objc func keybooardWillShow(notification: NSNotification) {
        
        //scroll collection vire up when keyboard shows
        let indexpath = IndexPath(item: MessageArray.count - 1, section: 0)
        collection.scrollToItem(at: indexpath, at: .top, animated: true)
        
        //getting tabbar height
        let tabbarHeight = tabBarController?.tabBar.frame.size.height
        
        //getting keyboard information
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        //getting keyboard duration animation time
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey]
        
        //keyboard animation duration witch is 0.25
        let kbd = keyboardDuration as! Double
        
        //keyboard frame
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        //keyboard height
        let keyboardHeight = keyboardRectangle.height
        
        //when keyboard show the srcreen will adjust
        collection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: keyboardHeight + 8 + tabbarHeight!, right: 0)
        
        //ajusting container view when keyboard shows
        containerViewBottomAnchor?.constant = -keyboardHeight + tabbarHeight!
        
        //animating the ajustment
        UIView.animate(withDuration: kbd) {
            
            //updates any constraints that are pending changed
            self.view.layoutIfNeeded()
        }
            }
    
    //key board will hide function
    @objc func keybooardWillHide (notification: NSNotification) {
        
        //keyboard will hide notification
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey]
        
        //keyboard will hide duration speed which is 0.25
        let kbd = keyboardDuration as! Double
        
        //fix screen when keyboard goes away
        collection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        
        //putcontainer view back at bottom
        containerViewBottomAnchor?.constant = 0
        
        //animate putting container view back at bottom
        UIView.animate(withDuration: kbd) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
 //when view dissapears remove observers
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
//when screen goes landscape, the collection view would fix
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collection.collectionViewLayout.invalidateLayout()
    }
    
    //observe message functions
    func observeMessages() {
       
      
        
        //current user id
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        //database reference to usermessages with current id and user id
        let ref = Database.database().reference().child("usermessages").child(uid).child(toid!)
        
        //observing the message added
        ref.observe(.childAdded, with: { (snapshot) in
            
            //message id of current user
            let messageId = snapshot.key
            
            //getting the message in chat messages with message id
            let messageref = Database.database().reference().child("chatmessages").child(messageId)
            
            //obseving infomation from the message
            messageref.observeSingleEvent(of: .value, with: { (snapshot2) in
            
               // assiging imfomation to dictionary
                guard var dictionary = snapshot2.value as? [String : Any] else{
                    return
                }
             
                //storing the messages for current user in varible message
             let message = chatMessages(dictionary: dictionary)
                
                
                if self.childPartherID(fromid: message.fromid!, toid: message.toid!) == self.user?.UserID || (self.staff?.UserID != nil) {
                   
                    self.MessageArray.append(message)
                    
                    DispatchQueue.main.async {
                        
                        
                        self.collection.reloadData()
                        
                        //an index path reference
                        let indexpath = IndexPath(item: self.MessageArray.count - 1, section: 0)
                        
                        //make screen aways scroll to bottom when new message
                        self.collection.scrollToItem(at: indexpath, at: .bottom, animated: true)
                    }
                }
                
                
              
               
                
                
                
               
                
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    //childparther function
    func childPartherID(fromid: String, toid: String) -> String {
        return fromid == Auth.auth().currentUser?.uid ? toid : fromid
    }
    
 //send button function
    @objc func handleSend() {
        
     sendmessage()
        
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendmessage()
        return true
    }
    
    func sendmessage(){
        //creating reference in database for messages
        let Childref =  Database.database().reference().child("chatmessages").childByAutoId()
        
        if staff == nil {
            userorstaffid.removeAll()
            //apply tenant id if staff is nil
            let userid = user!.UserID
            userorstaffid.append(userid!)
        }
        if user == nil {
            userorstaffid.removeAll()
            //if tenant user is nil apply staff id
            let userid = staff!.UserID
            userorstaffid.append(userid!)
        }
        
        //current user id
        let fromid = Auth.auth().currentUser!.uid
        
        //setting a date as time stamp
        let timeStamp = NSDate().timeIntervalSince1970 as NSNumber
        let values = ["text" : textfield.text!, "userid" : userorstaffid[0], "fromid" : fromid, "timestamp" : timeStamp] as [String : Any]
        
        //empty text when send is clicked
        textfield.text = ""
        
        //send in the values to  database
        Childref.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
            }
            
            //database reference to usermessages with current user id
            let userMessageRef = Database.database().reference().child("usermessages").child(fromid).child(self.userorstaffid[0])
            
            //the message from current user
            let messageid = ref.key!
            
            //create message for user under usermessages in database
            userMessageRef.updateChildValues([messageid : 1]) { (error, Reference) in
                
            }
            
            
            
            
            
            
            
            //create reference in data base for the TO user can receve message uunder his id also
            let toUserMessage = Database.database().reference().child("usermessages").child(self.userorstaffid[0]).child(fromid)
            toUserMessage.updateChildValues([messageid : 1])
        }
    }
    
    
//collection view number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return MessageArray.count
    }
    
    //cell for item in collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! Chatcell
        
        cell.ChatLogController = self
        
        
            let message = MessageArray[indexPath.item]
        cell.message = message
      
        cell.messagesView.text = message.text
        
        //seting profile pics from user if staff == nil
        if staff == nil {
            if let profileImageUrl = self.user?.ProfilePic {
                cell.profileIMageView.loadImageUsingCache(urlString: profileImageUrl)
            }
        }
        
        //setting profile pics for staff if user == nil
        if user == nil {
            if let profileImageUrl = self.staff?.ProfilePic {
                cell.profileIMageView.loadImageUsingCache(urlString: profileImageUrl)
               
            }
            
        }
        
        //if message is from current user set bubbles to right, set bubbles colors blue, set, text white, and ativate right anchor and turn off left
        if message.fromid == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
            cell.messagesView.textColor = .white
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
            cell.profileIMageView.isHidden = true
            cell.imageborder.isHidden = true
            
        }else {
            //if message is from other user set bubbles to left and turn color gray,set text to black, and activate left anchor and turn off right
            cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.messagesView.textColor = .black
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleViewRightAnchor?.isActive = false
            cell.profileIMageView.isHidden = false
            cell.imageborder.isHidden = false
            
        }
        //if we can assign text ,set the bubble width to wrap aroung text
        if let text = message.text {
            cell.messagesView.isHidden = false
        //setting the bubble width to wrap around text
        cell.bubbleWidthAchor?.constant = estimatedFrameaforatext(text: message.text!).width + 20
            
            //if images from message is not nil set width to 200
        }else if message.imageurl != nil {
            cell.messagesView.isHidden = true
            cell.bubbleWidthAchor?.constant = 200
        }
       
            
       //if we can assgin a picture from messages
        if let messageURL = message.imageurl {
           
            //load the pic
            cell.messageImageView?.loadImageUsingCache(urlString: messageURL)
            
            //do not hide the image view
            cell.messageImageView?.isHidden = false
            
            //back ground color clear
            cell.bubbleView.backgroundColor = .clear
        }else {
            //if we cannot load, hide back ground pic
            cell.messageImageView?.isHidden = true
        }
        
        cell.playButton?.isHidden = message.videourl == nil
        
        return cell
    }
    
    
    
    //size for item in collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //height varible
         var height: CGFloat = 80
        
        //reference to chatmessages
        let message = MessageArray[indexPath.item]
        
        //if we can assign text
        if let text = message.text {
            
            //height varible == texts height
            height = estimatedFrameaforatext(text: text).height
            
            //else if there is a image use this height for height varible
        }else if let imagewidth = message.imagewidth?.floatValue ,let imageheight = message.imageheight?.floatValue {
            height = CGFloat(imageheight / imagewidth * 200)
        }
        return CGSize(width: view.frame.width, height: height + 20)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Send?.isEnabled = true
        return true
    }
    
    //getting frame function for text
    func estimatedFrameaforatext(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    var startingframe: CGRect?
    var blackBackground: UIView?
    var startingImageView: UIImageView?
    
    func performZoomInForStartingImageView(startingImageView: UIImageView){
        
        self.startingImageView = startingImageView
        startingframe = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        self.startingImageView?.isHidden = true
        let zoomingImage = UIImageView(frame: startingframe!)
        zoomingImage.layer.cornerRadius = 16
        zoomingImage.clipsToBounds = true
        zoomingImage.backgroundColor = .red
        zoomingImage.image = startingImageView.image
        zoomingImage.isUserInteractionEnabled = true
        zoomingImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keywindow = UIApplication.shared.keyWindow{
            blackBackground = UIView(frame: keywindow.frame)
            blackBackground?.alpha = 0
            blackBackground?.backgroundColor = .black
           
            
            keywindow.addSubview(blackBackground!)
            keywindow.addSubview(zoomingImage)
            
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                
                let height = (self.startingframe?.height)! / (self.startingframe?.width)! * keywindow.frame.width
                
                zoomingImage.frame = CGRect(x: 0, y: 0, width: keywindow.frame.width, height: height)
                zoomingImage.layer.cornerRadius = 0
                
                zoomingImage.center = keywindow.center
                self.blackBackground?.alpha = 1
                self.bottomContainerView?.alpha = 0
                
            }, completion: nil)
            
        }
    }
    
    @objc func handleZoomOut (tapgesture: UITapGestureRecognizer){
        if let zoomOutIMage = tapgesture.view {
            
           
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                zoomOutIMage.frame = self.startingframe!
                self.blackBackground?.alpha = 0
                self.bottomContainerView?.alpha = 1
            }) { (completed: Bool) in
                zoomOutIMage.removeFromSuperview()
                self.startingImageView?.isHidden = false
                zoomOutIMage.layer.cornerRadius = 16
            }
        }
    }
    
}


//collection view cell
class Chatcell: UICollectionViewCell {
    
    var ChatLogController: ChatLogController?
    var activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    var message: chatMessages?
    var messagesView = UITextView()
    let bubbleView = UIView()
    let imageborder = UIView()
    let profileIMageView = UIImageView()
    var messageImageView: UIImageView?
    var playButton: UIButton?
    //bubble view anchor
    var bubbleWidthAchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        contentView.addSubview(imageborder)
        contentView.addSubview(profileIMageView)
        playButton = UIButton(type: .system)
       // playButton?.setTitle("play video", for: .normal)
        playButton?.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "videoPlayButton")
        playButton?.setImage(image, for: .normal)
        playButton?.tintColor = .red
        //profile image anchors and confuguration
        profileIMageView.translatesAutoresizingMaskIntoConstraints = false
        profileIMageView.image = UIImage(named: "BlankProfilePic.jpg")
        profileIMageView.layer.cornerRadius = 20
        profileIMageView.clipsToBounds = true
        profileIMageView.contentMode = .scaleAspectFill
        profileIMageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        profileIMageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        profileIMageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileIMageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        //message imageview anchos and confuguration
        messageImageView = UIImageView()
        messageImageView!.backgroundColor = .white
        messageImageView!.layer.cornerRadius = 16
        messageImageView!.clipsToBounds = true
        messageImageView!.contentMode = .scaleAspectFill
        messageImageView!.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(messageImageView!)
        messageImageView!.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView!.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView!.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView!.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        messageImageView?.isUserInteractionEnabled = true
        messageImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
    
        bubbleView.addSubview(playButton!)
        playButton?.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton?.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton?.addTarget(self, action: #selector(handleplay), for: .touchUpInside)
        
        bubbleView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        //imageborder confuguration and anchors
        imageborder.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        imageborder.translatesAutoresizingMaskIntoConstraints = false
        imageborder.layer.cornerRadius = 21
        imageborder.clipsToBounds = true
        imageborder.widthAnchor.constraint(equalToConstant: 42).isActive = true
        imageborder.heightAnchor.constraint(equalToConstant: 42).isActive = true
        imageborder.centerXAnchor.constraint(equalTo: profileIMageView.centerXAnchor).isActive = true
        imageborder.centerYAnchor.constraint(equalTo: profileIMageView.centerYAnchor).isActive = true
        
        //bubble view confuguration and anchors
        bubbleView.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
        contentView.addSubview(bubbleView)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileIMageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bubbleViewRightAnchor!.isActive = true
        bubbleWidthAchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAchor!.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        //message view confugurations and anchors
        contentView.backgroundColor = .white
       messagesView.font = UIFont.systemFont(ofSize: 16)
        messagesView.text = "Hey This Is Just Dummy Text To Put in"
        messagesView.isEditable = false
        messagesView.translatesAutoresizingMaskIntoConstraints = false
        messagesView.backgroundColor = .clear
        messagesView.textColor = .white
        contentView.addSubview(messagesView)
        messagesView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        messagesView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messagesView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messagesView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
    }
    var playerlayer: AVPlayerLayer?
    var player: AVPlayer?
    
    @objc func handleplay(){
        if let videoUrl = message?.videourl, let url = URL(string: videoUrl) {
            player = AVPlayer(url: url)
            playerlayer = AVPlayerLayer(player: player)
            playerlayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerlayer!)
            player?.play()
            activityIndicatorView.startAnimating()
        
        }}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerlayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
        
    }
    
   @objc func handleZoomTap(_tapGesture: UITapGestureRecognizer) {
    if message?.videourl != nil {
        return
    }
    
    if let imageView = _tapGesture.view as? UIImageView {
    ChatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
    }}
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }

