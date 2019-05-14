//
//  TenantTabbar.swift
//  Rose Associates
//
//  Created by user145580 on 5/12/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import SwipeableTabBarController


class TenantTabbar: SwipeableTabBarController {
   // var CommunityChatController: CommunityChat?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        SwipeAnimationType.sideBySide
        
        
        let CommunityChatNavBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationCommunityChat")
        let EditProfieController = EditProfile()
    
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white
        
        
        let EditProfileNavBar = UINavigationController(rootViewController: EditProfieController )
        let messageNavBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "messagenavbar")
        
        let resources = Resources()
        let resourcesNavBar = UINavigationController(rootViewController: resources)
        
        let tenantsandniebors = TenantsAndNeibors()
        let tenantandnieborsnavbar = UINavigationController(rootViewController: tenantsandniebors)
       
        EditProfileNavBar.title = "Edit Profile"
        resourcesNavBar.title = "Resources"
        
        tenantandnieborsnavbar.title = "Nirebors"
        EditProfileNavBar.navigationBar.prefersLargeTitles = true
        EditProfileNavBar.navigationBar.barTintColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
        EditProfileNavBar.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        resourcesNavBar.navigationBar.prefersLargeTitles = true
        resourcesNavBar.navigationBar.barTintColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
        resourcesNavBar.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        tenantandnieborsnavbar.navigationBar.prefersLargeTitles = true
        tenantandnieborsnavbar.navigationBar.barTintColor = UIColor(red: 40/255, green: 170/255, blue: 192/255, alpha: 1)
        tenantandnieborsnavbar.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        viewControllers = [EditProfileNavBar, tenantandnieborsnavbar, CommunityChatNavBar, messageNavBar, resourcesNavBar ]
        
        selectedIndex = 2
        
        
        EditProfileNavBar.tabBarItem.image = UIImage(named: "editprofilepic.png")
        EditProfileNavBar.tabBarItem.title = nil
        EditProfileNavBar.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        EditProfileNavBar.tabBarItem.selectedImage = UIImage(named: "editprofileselected.png")
        
        
        
        messageNavBar.tabBarItem.image = UIImage(named: "message.png")
        messageNavBar.tabBarItem.title = nil
        messageNavBar.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        messageNavBar.tabBarItem.selectedImage = UIImage(named: "messageselected.png")
        
        resourcesNavBar.tabBarItem.image = UIImage(named: "resources.png")
        resourcesNavBar.tabBarItem.title = nil
        resourcesNavBar.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        resourcesNavBar.tabBarItem.selectedImage = UIImage(named: "resoucesselected.png")
        
        
        tenantandnieborsnavbar.tabBarItem.image = UIImage(named: "tenants.png")
        tenantandnieborsnavbar.tabBarItem.title = nil
        tenantandnieborsnavbar.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        tenantandnieborsnavbar.tabBarItem.selectedImage = UIImage(named: "tenantsselected.png")
        
        
        CommunityChatNavBar.tabBarItem.image = UIImage(named: "groupchat.png")
        CommunityChatNavBar.tabBarItem.title = nil
        CommunityChatNavBar.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        CommunityChatNavBar.tabBarItem.selectedImage = UIImage(named: "groupchatselected.png")
        CommunityChatNavBar.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        
    }
    
  
    
 
}
