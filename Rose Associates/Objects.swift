//
//  Tenants.swift
//  Rose Associates
//
//  Created by user145580 on 4/17/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import Firebase


class Tenant2s: NSObject {
    var LastName: String?
    var FirstName: String?
    var Language: String?
    var ProfilePic: String?
    var Unit: String?
    var Bio: String?
    var Birthday: String?
    var UserType: String?
    var UserID: String?
    init(LastName: String?, FirstName: String?, Language: String?, ProfilePic: String?, Unit: String?, Bio: String?, Birthday: String?, UserType: String?, UserID: String?){
        self.LastName = LastName
        self.FirstName = FirstName
        self.Language = Language
        self.ProfilePic = ProfilePic
        self.Unit = Unit
        self.Bio = Bio
        self.Birthday = Birthday
        self.UserType = UserType
        self.UserID = UserID
    }
    
    }



class Staff2s: NSObject {
    
    var LastName: String?
    var FirstName: String?
    var Language: String?
    var ProfilePic: String?
    var Position: String?
    var Bio: String?
    var Birthday: String?
    var UserType: String?
    var UserID: String?
    
    init(LastName: String?, FirstName: String?, Language: String?, ProfilePic: String?, Position: String?, Bio: String?, Birthday: String?, UserType: String?, UserID: String?){
        self.LastName = LastName
        self.FirstName = FirstName
        self.Language = Language
        self.ProfilePic = ProfilePic
        self.Position = Position
        self.Bio = Bio
        self.Birthday = Birthday
        self.UserType = UserType
        self.UserID = UserID
        
    }
}




class GroupChatMessages: NSObject {
    var fromid: String?
    var text: String?
    var imageurl: String?
    var videourl:String?
    var timestamp: NSNumber?
    var imageheight: NSNumber?
    var imagewidth: NSNumber?
    var type: String?
    init(dictionary: [String : Any]){
        self.fromid = dictionary["fromid"] as? String
        self.text = dictionary["text"] as? String
        self.imageurl = dictionary["imageurl"] as? String
        self.imagewidth = dictionary["imagewidth"] as? NSNumber
        self.imageheight = dictionary["imageheight"] as? NSNumber
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.videourl = dictionary["videourl"] as? String
        self.type = dictionary["type"] as? String
    }
}


class chatMessages: NSObject {
    var fromid: String?
    var toid: String?
    var text: String?
    var timestamp : NSNumber?
    var imageurl: String?
    var imageheight: NSNumber?
    var imagewidth: NSNumber?
    var videourl: String?
    
    
    
    
    init(dictionary: [String : Any]){
        super .init()
        self.fromid = dictionary["fromid"] as? String
        self.toid = dictionary["userid"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageurl = dictionary["imageurl"] as? String
        self.imageheight = dictionary["imagewidth"] as? NSNumber
        self.videourl = dictionary["videourl"] as? String
    }
}
