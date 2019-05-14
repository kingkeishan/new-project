//
//  ViewProfilePage.swift
//  Rose Associates
//
//  Created by user145580 on 5/11/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit


class ViewProfilePage: UIViewController {
    
    var user: Tenant2s? {
        didSet {
            navigationItem.title = (user?.FirstName)! + " " + (user?.LastName)!
        }
    }
    var staff: Staff2s? {
        didSet {
            navigationItem.title = (staff?.FirstName)! + " " + (staff?.LastName)!
        }
    }
    var image: UIImageView?
    var blackBackgroundView: UIView?
    var startingFrame: CGRect?
    var ProfilePic: UIImageView?
    var backgroundview: UIView?
    var profilepicBorderView: UIView?
    var bioLabel: UILabel?
    var seperatorline: UIView?
    var textview: UITextView?
    var sendMessageButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        bioLabel = UILabel()
        seperatorline = UIView()
        textview = UITextView()
        sendMessageButton = UIButton(type: .system)
        backgroundview = UIView()
        profilepicBorderView = UIView()
        ProfilePic = UIImageView()
        view.addSubview(backgroundview!)
        view.addSubview(profilepicBorderView!)
        view.addSubview(ProfilePic!)
        view.addSubview(sendMessageButton!)
        view.addSubview(bioLabel!)
        view.addSubview(seperatorline!)
        view.addSubview(textview!)
        
        backgroundview?.backgroundColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
        backgroundview?.translatesAutoresizingMaskIntoConstraints = false
        backgroundview?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundview?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundview?.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        backgroundview?.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
        
        
        profilepicBorderView?.translatesAutoresizingMaskIntoConstraints = false
        profilepicBorderView?.backgroundColor = .white
        profilepicBorderView?.layer.cornerRadius = 150
        profilepicBorderView?.clipsToBounds = true
        profilepicBorderView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilepicBorderView?.centerYAnchor.constraint(equalTo: (backgroundview?.bottomAnchor)!).isActive = true
        profilepicBorderView?.widthAnchor.constraint(equalToConstant: 300).isActive = true
        profilepicBorderView?.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        ProfilePic?.translatesAutoresizingMaskIntoConstraints = false
        ProfilePic?.isUserInteractionEnabled = true
        ProfilePic?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlezoom)))
        ProfilePic?.layer.cornerRadius = 125
        ProfilePic?.clipsToBounds = true
        ProfilePic?.image = UIImage(named: "BlankProfilePic.jpg")
        ProfilePic?.contentMode = .scaleAspectFill
        ProfilePic?.loadImageUsingCache(urlString: (user?.ProfilePic)!)
        ProfilePic?.centerYAnchor.constraint(equalTo: (profilepicBorderView?.centerYAnchor)!).isActive = true
        ProfilePic?.centerXAnchor.constraint(equalTo: (profilepicBorderView?.centerXAnchor)!).isActive = true
        ProfilePic?.widthAnchor.constraint(equalToConstant: 250).isActive = true
        ProfilePic?.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        bioLabel?.text = "Bio"
        bioLabel?.textColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
        bioLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bioLabel?.translatesAutoresizingMaskIntoConstraints = false
        bioLabel?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioLabel?.topAnchor.constraint(equalTo: (profilepicBorderView?.bottomAnchor)!, constant: 0).isActive = true
       
        //bioLabel?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        textview?.translatesAutoresizingMaskIntoConstraints = false
        textview?.font = UIFont.boldSystemFont(ofSize: 15)
        textview?.textColor = .white
        textview?.layer.cornerRadius = 8
        textview?.clipsToBounds = true
        textview?.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        textview?.text = user?.Bio ?? staff?.Bio
        textview?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textview?.topAnchor.constraint(equalTo: (bioLabel?.bottomAnchor)!, constant: 20).isActive = true
        let viewWidthdivided5 = view.frame.width / 5 * 4
        textview?.widthAnchor.constraint(equalToConstant: viewWidthdivided5).isActive = true
       textview?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        sendMessageButton?.translatesAutoresizingMaskIntoConstraints = false
        sendMessageButton?.layer.cornerRadius = 5
        sendMessageButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        sendMessageButton?.tintColor = .white
        sendMessageButton?.clipsToBounds = true
        sendMessageButton?.setTitle("Send Message", for: .normal)
        sendMessageButton?.backgroundColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
        sendMessageButton?.topAnchor.constraint(equalTo: (textview?.bottomAnchor)!, constant: 20).isActive = true
        sendMessageButton?.widthAnchor.constraint(equalTo: (textview?.widthAnchor)!).isActive = true
        sendMessageButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendMessageButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendMessageButton?.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        
       
        
        
        
        
    }
    
    
    @objc func handlezoom(_ tapGestor: UITapGestureRecognizer) {
        
        if let image = tapGestor.view as? UIImageView {
        startingFrame = image.superview?.convert(image.frame, to: nil)
            
           // self.image!.isHidden = true
            let zoomingimage = UIImageView(frame: startingFrame!)
            zoomingimage.layer.cornerRadius = 125
            zoomingimage.contentMode = .scaleAspectFill
            zoomingimage.clipsToBounds = true
            zoomingimage.isUserInteractionEnabled = true
            zoomingimage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOutImage)))
            zoomingimage.backgroundColor = .red
            zoomingimage.image = image.image
            if let keywindow = UIApplication.shared.keyWindow {
                blackBackgroundView = UIView(frame: keywindow.frame)
                blackBackgroundView!.alpha = 0
                blackBackgroundView?.backgroundColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
                keywindow.addSubview(blackBackgroundView!)
                keywindow.addSubview(zoomingimage)
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    let height = (self.startingFrame!.height) / (self.startingFrame!.width) * keywindow.frame.width
                    zoomingimage.frame = CGRect(x: 0, y: 0, width: keywindow.frame.width, height: height)
                    zoomingimage.layer.cornerRadius = 0
                    zoomingimage.center = keywindow.center
                    self.blackBackgroundView?.alpha = 1
                    
                }, completion: nil)
            }
            
        }
    
    
    }
    
    @objc func zoomOutImage(_ tapGestor: UITapGestureRecognizer){
        if let zoomoutimage = tapGestor.view {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                zoomoutimage.frame = self.startingFrame!
                zoomoutimage.layer.cornerRadius = 125
                self.blackBackgroundView?.alpha = 0
            }) { (true) in
                zoomoutimage.layer.cornerRadius = 125
                zoomoutimage.removeFromSuperview()
                self.image?.isHidden = false
            }
        }
    }
    
    @objc func sendMessage() {
        
        let ChatLog = ChatLogController()
        if user == nil {
            ChatLog.staff = staff }
        if staff == nil {
        ChatLog.user = user
        }
        self.navigationController?.pushViewController(ChatLog, animated: true)
    }
}

