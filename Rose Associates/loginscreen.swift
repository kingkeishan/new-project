//
//  LoginScreen.swift
//  Rose Associates
//
//  Created by user145580 on 4/19/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import Firebase

class LoginScreen: UIViewController, UITextFieldDelegate {
    //Email duumy to enable full name log in only
    let emailDummy = "@gmail.com"
    
    //Dummy Password to enable sighn in with full name onlt
    let Password = "RedRose"
    
    //first and last name text fields
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    
    //login button outlet connection
    @IBOutlet weak var LoginButtonOutlet: UIButton!
    
    //container view for text fields
    @IBOutlet weak var ContainerView: UIView!
    
    //seperator line in middle of text fields
    @IBOutlet weak var SeperatorLine: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //name text fields delegates
       FirstNameTextField.delegate = self
        LastNameTextField.delegate = self
        
        
      
        //containerview confugurations
        ContainerView.backgroundColor = .white
        ContainerView.layer.cornerRadius = 5
        ContainerView.clipsToBounds = true
        
        //containerview anchor constraints
        ContainerView.translatesAutoresizingMaskIntoConstraints = false
        ContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        ContainerView.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        ContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //firstname text field anchor constraints
        FirstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        FirstNameTextField.topAnchor.constraint(equalTo: ContainerView.topAnchor).isActive = true
        FirstNameTextField.leftAnchor.constraint(equalTo: ContainerView.leftAnchor, constant: 12).isActive = true
        FirstNameTextField.rightAnchor.constraint(equalTo: ContainerView.rightAnchor).isActive = true
        FirstNameTextField.heightAnchor.constraint(equalTo: ContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        //lastname text field anchor constraints
        LastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        LastNameTextField.bottomAnchor.constraint(equalTo: ContainerView.bottomAnchor).isActive = true
        LastNameTextField.leftAnchor.constraint(equalTo: ContainerView.leftAnchor, constant: 12).isActive = true
        LastNameTextField.rightAnchor.constraint(equalTo: ContainerView.rightAnchor).isActive = true
        LastNameTextField.heightAnchor.constraint(equalTo: ContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        //login button constraints and confugureations
        LoginButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        LoginButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginButtonOutlet.layer.cornerRadius = 5
        LoginButtonOutlet.clipsToBounds = true
        LoginButtonOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        LoginButtonOutlet.widthAnchor.constraint(equalTo: ContainerView.widthAnchor).isActive = true
        LoginButtonOutlet.topAnchor.constraint(equalTo: ContainerView.bottomAnchor, constant: 20).isActive = true
        LoginButtonOutlet.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //seperator line and confugurations
        SeperatorLine.translatesAutoresizingMaskIntoConstraints = false
        SeperatorLine.topAnchor.constraint(equalTo: FirstNameTextField.bottomAnchor).isActive = true
        SeperatorLine.widthAnchor.constraint(equalTo: ContainerView.widthAnchor).isActive = true
        SeperatorLine.centerXAnchor.constraint(equalTo: ContainerView.centerXAnchor).isActive = true
        SeperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        SeperatorLine.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
           }
 

        
    
    //login outlet
    @IBAction func LogInButton(_ sender: Any) {
        signinusers()
        }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signinusers()
       
        return true
        
    }
    
    //signing in users
    func signinusers() {
        
        //signing in with firebase
        Auth.auth().signIn(withEmail: FirstNameTextField.text! + LastNameTextField.text! + emailDummy, password: Password) { (result, loginerror) in
            
            //print error if error
            if loginerror != nil {
                print(loginerror)
            }else {
           //if login was successful
                
                //manager Page Path
                let managerPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarManagement")
                
                //tenant Page path
                let tenantPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TenantEnterInfo")
                
                //current user sign in id
                let Userid = Auth.auth().currentUser?.uid
                
                //checking user type to direct them to app location
                Database.database().reference().child("Users").child(Userid!).child("UserType").observeSingleEvent(of: .value, with: { (snapshot) in
                    switch snapshot.value as! String {
                        
                        //direct user to manager page as manager
                    case "admin" : self.present(managerPage, animated: true, completion: nil)
                    
                        //direct tenant to tenant page as tenant
                    case "tenant" : self.present(tenantPage, animated: true, completion: nil)
                    
                    //direct staff to staff page as staff
                    case "staff" : self.present(managerPage, animated: true, completion: nil)
                  
                        //return if case is else
                    default : return
                        
                    }
                    
                }
                )
                
                
                
                
                
                
            }}
        
        
    }
}
