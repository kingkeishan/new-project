//
//  ViewController.swift
//  Rose Associates
//
//  Created by user145580 on 4/13/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import Firebase


class ManagementAddUser: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //auto Password For Registration
    let password :String = "RedRose"
    
    //Email Dummy to just use first and last anme
    let emailDummy :String = "@Gmail.com"
    //SearchBar Outlet
    @IBOutlet weak var SearchBar: UISearchBar!
    var Stafftextarray = [String]()
    var textarray = [String]()
    //NameTextfields and Unit
    var FirstnameTextField = UITextField()
    var LastnameTextField = UITextField()
    var UnitTextField = UITextField()
    var StaffTextField = UITextField()
    var StaffLastnameTextField = UITextField()
    var StaffFirstnameTextField = UITextField()
    var updatedFirstNameTextField = UITextField()
    var updatedLastNameTextField = UITextField()
    var updatedUnitandPositionTextField = UITextField()
    var updatedTenantandStaffTextFields = [String]()
    
    
    //Tenants from database array
    var tenantUsers = [Tenant2s]()
    var staffUsers = [Staff2s]()
    
    //Searching tenant Array
    var SearchTenantArray = [Tenant2s]()
    //when searching on searchbar
    var searching = false
    var SearchBarScopeIndex = Bool()
    
    
    
    //outlet for table
    @IBOutlet weak var TenantTableView: UITableView!
    var staffIsClick = [Staff2s]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchbar delegate
        SearchBar.delegate = self
        
        //searchbar scope button names "tenant and staff"
        SearchBar.scopeButtonTitles = ["Tenants" , "Staff"]
      
        
      
      
        //Tableview delegates
        TenantTableView.delegate = self
        TenantTableView.dataSource = self
        
        //Tableview row height
  TenantTableView.rowHeight = 100
        
        //table view with no seperator lines
       TenantTableView.separatorStyle = .none
       
        //fetching tenants data from database
        fetchTenants()
        imformationchanged()
        TenantTableView.allowsSelection = true
        
    }
    
    
    

    
    //Logging out and going back to login page
    @IBAction func LogOutButton(_ sender: Any) {
        do{
            //signning out
            try Auth.auth().signOut() }
        catch {
            print("error")
        }
        //if current user id is nil
        if Auth.auth().currentUser?.uid == nil {
           //disssmiss back to to login screen if id is nil
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    //Fetching data from database
    func fetchTenants () {
        self.tenantUsers.removeAll()
        self.staffUsers.removeAll()        //Snapshot reference
        Database.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
            
            //Converting Snapshot to a dictionary
            let dictionary = snapshot.value as! [String : AnyObject]
            
            //Putting Snapshot data in Object
            for (key,value) in dictionary {
                
                //checking if user have unit or position option
                if key == "Unit" {
                    
                    //storing snapshot imfomation in teantimfomation if user is a tenant
                    let tenantImformation = Tenant2s(LastName: dictionary["LastName"] as! String, FirstName: dictionary["FirstName"] as! String, Language: dictionary["Language"] as! String, ProfilePic: dictionary["ProfilePic"] as! String, Unit: dictionary["Unit"] as! String, Bio: dictionary["Bio"] as! String, Birthday: dictionary["Birthday"] as! String, UserType: dictionary["UserType"] as! String, UserID: snapshot.key)
                                                self.tenantUsers.append(tenantImformation)
                }
                //checking if user is have position option in stead of
                if key == "Position" {
                    //storing snapshot imformation to staffImfomation of user is staff
                    let StaffImformation = Staff2s(LastName: dictionary["LastName"] as! String, FirstName: dictionary["FirstName"] as! String, Language: dictionary["Language"] as! String, ProfilePic: dictionary["ProfilePic"] as! String, Position: dictionary["Position"] as! String, Bio: dictionary["Bio"] as! String, Birthday: dictionary["Birthday"] as! String, UserType: dictionary["UserType"] as! String, UserID: snapshot.key)
                    
                    self.staffUsers.append(StaffImformation)
                    
                }
            
            }
           
            
            
            
            self.timer?.invalidate()
             self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
            
    
            
        }, withCancel: nil)

        
    
        
    }
    var timer: Timer?
    
    
    func imformationchanged(){
        Database.database().reference().child("Users").observe(.childChanged, with: { (snapshot) in
           
            self.fetchTenants()
            
        }, withCancel: nil)
        
    }
    
    
    
    @objc func handleReload(){
        DispatchQueue.main.async {
        
        self.TenantTableView.reloadData()
            print("printing")
        }
        
    }
    
        
    
   
    
    //add tenantBarButton
    @IBAction func AddTenantBarButton(_ sender: Any) {
        print(SearchBar.selectedScopeButtonIndex)
       
        
        //if search bar is on staff
        if SearchBarScopeIndex {
            
            //Empty text array and staff text
            Stafftextarray.removeAll()
            textarray.removeAll()
            
            //alert controller for staff
            let AddTenantAlert = UIAlertController(title: "Register Staff Member", message: nil, preferredStyle: .alert)
            
            //adding a textfield to alert controller
            AddTenantAlert.addTextField { (Firstname) in
                
                Firstname.placeholder = "First Name"
                Firstname.borderStyle = .roundedRect
                self.StaffFirstnameTextField = Firstname
                //adding delegate to text field
                self.StaffFirstnameTextField.delegate = self        }
           
            //adding second text filed to alert controller
            AddTenantAlert.addTextField { (LastName) in
                LastName.placeholder = "Last Name"
                LastName.borderStyle = .roundedRect
                self.StaffLastnameTextField = LastName
                self.StaffLastnameTextField.delegate = self
            }
            //adding third text field to alert controller
            AddTenantAlert.addTextField { (Unit) in
                
                Unit.placeholder = "Position"
                Unit.borderStyle = .roundedRect
                self.StaffTextField = Unit
                self.StaffTextField.delegate = self
                
            }
            
            //adding a action for alert controller for staff
            let RegisterTenantAction = UIAlertAction(title: "Register Staff", style: .default) { (alert) in
                
                
                
                
                
                //appeending all entrys to array
                self.Stafftextarray.append(self.StaffFirstnameTextField.text!)
                self.Stafftextarray.append(self.StaffLastnameTextField.text!)
                self.Stafftextarray.append(self.StaffTextField.text!)
                
                //Registering staff to firebase
                Auth.auth().createUser(withEmail: self.Stafftextarray[0] + self.Stafftextarray[1] + self.emailDummy, password: self.password) { (Result, error) in
                    if error != nil {
                        
                        print(error)
                        
                    }else {
                        
                        //fetching current user id
                        let UserID = Auth.auth().currentUser!.uid
                        
                        
                        //Declaring Database Reference
                        let ref = Database.database().reference(fromURL: "https://rose-associates-59045.firebaseio.com")
                        
                        //Inputs for Register Users
                        let Values = ["FirstName" : self.Stafftextarray[0], "LastName" : self.Stafftextarray[1], "Language" : "English", "Bio" : "Hey", "ProfilePic" : "www.url.com", "Birthday" : Date().description, "Position" : self.Stafftextarray[2], "UserType" : "staff"]
                        
                       //creating a reference for in data for user just register
                            ref.child("Users").child(UserID).setValue(Values)
                     
                      //  Database.database().reference().child("Users").child(UserID).updateChildValues(["UserID" : UserID])
                        //presenting alert controller if registration was sucessful
                        self.RegistrationSuccessAlert()
                        
                        //reloading table view
                        self.TenantTableView.reloadData()
                        
                        
                    }}}
            
            //adding a cancel button to alert controller
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            
            
            
            
            //Adding actions to AlertController
            AddTenantAlert.addAction(RegisterTenantAction)
            AddTenantAlert.addAction(cancel)
            
            
            //Presenting Alert Controller
            self.present(AddTenantAlert, animated: true, completion: nil)
            
            
        }
        //Empty text and staff arrays for entrys
      Stafftextarray.removeAll()
        textarray.removeAll()
        
        //creating a alert controller for registration
        let AddTenantAlert = UIAlertController(title: "Register Tenant", message: nil, preferredStyle: .alert)
        
        //adding a textfield for for first name
        AddTenantAlert.addTextField { (Firstname) in
            Firstname.placeholder = "First Name"
            Firstname.borderStyle = .roundedRect
           // Firstname.delegate = self
            self.FirstnameTextField = Firstname
            self.FirstnameTextField.delegate = self
            
            
            
            
        }
    //adding second text field for last name
        AddTenantAlert.addTextField { (LastName) in
            LastName.placeholder = "Last Name"
            LastName.borderStyle = .roundedRect
            
            self.LastnameTextField = LastName
            self.LastnameTextField.delegate = self
           // LastName.delegate = self
            
        }
        //adding third text field for unit
        AddTenantAlert.addTextField { (Unit) in
         
            Unit.placeholder = "Unit"
            Unit.borderStyle = .roundedRect
            self.UnitTextField = Unit
           // Unit.delegate = self
            self.UnitTextField.delegate = self
            
        }
    
        //adding action to register tenant
        let RegisterTenantAction = UIAlertAction(title: "Register Tenant", style: .default) { (alert) in
            
      
            
            
            
            //appeding entrys to array
            self.textarray.append(self.FirstnameTextField.text!)
            self.textarray.append(self.LastnameTextField.text!)
            self.textarray.append(self.UnitTextField.text!)
            
            //Register User
            Auth.auth().createUser(withEmail: self.textarray[0] + self.textarray[1] + self.emailDummy, password: self.password) { (Result, error) in
                if error != nil {
                 
                    print(error)
                    
                }else {
                    
                    //fetching User Id
                    let UserID = Auth.auth().currentUser!.uid
                    
                    //Declaring Database Reference
                    let ref = Database.database().reference(fromURL: "https://rose-associates-59045.firebaseio.com")
                    
                    //Inputs for Register Users
                    let Values = ["FirstName" : self.textarray[0], "LastName" : self.textarray[1], "Language" : "English", "Bio" : "Hey", "ProfilePic" : "www.url.com", "Birthday" : Date().description, "Unit" : self.textarray[2], "UserType" : "tenant"]
                    
                    
                    //creating refernce in database for user just sign in
                        ref.child("Users").child(UserID).setValue(Values)
                    
                  //  Database.database().reference().child("Users").child(UserID).updateChildValues(["UserID" : UserID])
            //registation sucess alert controller
               self.RegistrationSuccessAlert()
                    
                    //tableview reload
                    self.TenantTableView.reloadData()
                   
                    
                }}}
        //adding cancell button to alert controller
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        
      
            
       
        //Adding actions to AlertController
        AddTenantAlert.addAction(RegisterTenantAction)
        AddTenantAlert.addAction(cancel)
        
        
        //Presenting Alert Controller
        self.present(AddTenantAlert, animated: true, completion: nil)
        
     

                
            }
    //SearchBar Enter button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
    }
    //SearchBar text change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //new array of filter tenants
        SearchTenantArray = tenantUsers.filter({$0.Unit!.prefix(searchText.count) == searchText})
        
        //if searching
        searching = true
        
        //tableview reload
        TenantTableView.reloadData()
    }
        
    //Tableview did select at row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    
        
        //if searchscope bar for staff is highlighted
        if SearchBarScopeIndex {
            
            //staff users
            let staff = staffUsers[indexPath.row]
            //alert controller for staff
            staffwasclick(staff: staff)
            
            
        }else{
        
        //if searchbar scope button is on staff
        let tenants = tenantUsers[indexPath.row]
       //alertcontroller for tenants
            userWasClick(UserInfo: tenants)
       
        }
        
            
        TenantTableView.deselectRow(at: indexPath, animated: true)
        
    }
 
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TenantsManagementTableViewCell
        cell?.backgroundColor = .blue
    }

    
    //Tableview CELL
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       

        //if SearchBarScop is on staff
        if SearchBarScopeIndex {
            
            //Staff Cell
            let cell = TenantTableView.dequeueReusableCell(withIdentifier: "Staff", for: indexPath) as! StaffTableViewCell
            
            //staff users
            var staffList = staffUsers[indexPath.row]
            
            
            
            
            
            cell.PositionLabel.text = staffList.Position
            cell.StaffNameLabel.text = staffList.FirstName! + " " + staffList.LastName!
            
           return cell
        }else {
        
        //if searchbarscope is on use tenant cell
        let cell = TenantTableView.dequeueReusableCell(withIdentifier: "Tenants", for: indexPath) as! TenantsManagementTableViewCell
            //if searchBar is Searching
            if searching {
                
                //New Search Array for cells
                var searchTenants = SearchTenantArray[indexPath.row]
            
                cell.UnitLabel.text = searchTenants.Unit
                cell.NameLabel.text = searchTenants.FirstName! + " " + searchTenants.LastName!
                
                //Table reload when is searching
               // TenantTableView.reloadData()
                return cell
            }
        
                
                //putting Tenants in order by smallest aparment number
                tenantUsers.sort(by: {$0.Unit! < $1.Unit!})
                
                //tenants array
                let TenantList = tenantUsers[indexPath.row]
            
                cell.NameLabel.text = TenantList.FirstName! + " " + TenantList.LastName!
                
                //cell.CelIImage.layer.masksToBounds = true
                
                cell.UnitLabel.text = TenantList.Unit
            
           
                if let ProfileImageUrl = TenantList.ProfilePic {
                cell.CelIImage.loadImageUsingCache(urlString: ProfileImageUrl)
                    
                }
                
            
                
                return cell
        
            
            
        
        }
        
    }
    
    
    
    //SearchBarScope is selected
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 1 {
            TenantTableView.reloadData()
            SearchBarScopeIndex = true
            navigationItem.title = "Staff"
            SearchBar.placeholder = "Search Staff"
        } else {
            TenantTableView.reloadData()
            SearchBarScopeIndex = false
            navigationItem.title = "Tenant"
            SearchBar.placeholder = "Search by Unit"
        }
    }
    
    //table number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if SearchBar.selectedScopeButtonIndex == 1{
       
        
        return staffUsers.count
        
       }
       else {
        
        if searching {
            
        
            return SearchTenantArray.count }
       else {
            
     
            return tenantUsers.count
        
        }
    
        } }

    
    //alert Controller After Register Users
    func RegistrationSuccessAlert () {
        if SearchBarScopeIndex {
            let alert = UIAlertController(title: "You Have Register A Staff", message: nil, preferredStyle: .alert)
        
            
            let action = UIAlertAction(title: "ok", style: .default) { (alert) in
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
        let alert = UIAlertController(title: "You Have Register A Tenant", message: nil, preferredStyle: .alert)
    
        let action = UIAlertAction(title: "ok", style: .default) { (alert) in
            
            }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }}
    
    
    //if user was clicked alert controller
    func userWasClick(UserInfo: Tenant2s) {
        //alert controller for tenant
        let alert = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
        let messageAction = UIAlertAction(title: "Private Message", style: .default) { (alert) in
            
           // Send user to chat log for message
        let ChatLog = ChatLogController()
            ChatLog.user = UserInfo
           
            self.navigationController?.pushViewController(ChatLog, animated: true)
           
            
           
            
                  }
        let upDateUser = UIAlertAction(title: "Update User Info", style: .default) { (alert) in
            print(Auth.auth().currentUser?.uid)
            
            do{
            try Auth.auth().signOut()
            }catch {
                if error != nil {
                    print(error)
                }
            }
            if Auth.auth().currentUser == nil {
                Auth.auth().signIn(withEmail: UserInfo.FirstName!+UserInfo.LastName!+self.emailDummy, password: self.password, completion: { (result, error) in
                    if error != nil {
                        print(error)
                        
                        
                    }else {
                        
                    
                    
                        self.updateuser(FirstName: UserInfo.FirstName!, LastName: UserInfo.LastName!, UnitorPosition: UserInfo.Unit!)
                    
                    
                    } })
                
            
            }}
        let ViewProfile = UIAlertAction(title: "View Profile", style: .default) { (alert) in
            
            let viewprofilepage = ViewProfilePage()
            viewprofilepage.user = UserInfo
            self.navigationController?.pushViewController(viewprofilepage, animated: true)
            
        }
        let deleteUser = UIAlertAction(title: "Delete User", style: .destructive) { (alert) in
            do{
            
       try Auth.auth().signOut()
            }catch {
                if error != nil {
                    print(error)
                }
            }
            Auth.auth().signIn(withEmail: UserInfo.FirstName!+UserInfo.LastName!+self.emailDummy, password: self.password, completion: { (result, error) in
                if error != nil {
                    print(error)
                }else {
                    
                    self.deleteuser(FirstName: UserInfo.FirstName!, LastName: UserInfo.LastName!, UnitorPosition: UserInfo.Unit!)
                }
            })
        }
    
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
           
            print("cancel")
        }
        
        alert.addAction(messageAction)
        alert.addAction(upDateUser)
        alert.addAction(ViewProfile)
        alert.addAction(deleteUser)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func staffwasclick (staff: Staff2s){
        
        let alert = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
        let messageAction = UIAlertAction(title: "Send Message", style: .default) { (alert) in
            
            let ChatLog = ChatLogController()
            ChatLog.staff = staff
            
            self.navigationController?.pushViewController(ChatLog, animated: true)
            
            
            
            
        }
        let upDateUser = UIAlertAction(title: "Update User Info", style: .default) { (alert) in
            
            
            do{
                try Auth.auth().signOut()
            }catch {
                if error != nil {
                    print(error)
                }
            }
            if Auth.auth().currentUser == nil {
                Auth.auth().signIn(withEmail: staff.FirstName!+staff.LastName!+self.emailDummy, password: self.password, completion: { (result, error) in
                    if error != nil {
                        print(error)
                        
                        
                    }else {
                        
            
            self.updateuser(FirstName: staff.FirstName!, LastName: staff.LastName!, UnitorPosition: staff.Position!)
                        
                        
                        
                    } })
                
                
            }}
        let ViewProfile = UIAlertAction(title: "View Profile", style: .default) { (alert) in
            let viewprofilepage = ViewProfilePage()
            viewprofilepage.staff = staff
            self.navigationController?.pushViewController(viewprofilepage, animated: true)
            
        }
        let deleteUser = UIAlertAction(title: "Delete User", style: .destructive) { (alert) in
            print("Delete User")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("cancel")
            
        }
        
        alert.addAction(messageAction)
        alert.addAction(upDateUser)
        alert.addAction(ViewProfile)
        alert.addAction(deleteUser)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func deleteuser(FirstName: String, LastName:String, UnitorPosition: String) {
        
        let deletecontroller = UIAlertController(title: "Are you sure you want to delete \(FirstName) \(LastName)", message: nil, preferredStyle: .alert)
        let deleteaction = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("Users").child(uid!)
            ref.removeValue(completionBlock: { (error, reference) in
                if error != nil {
                    print(error)
                }else {
                    Auth.auth().currentUser?.delete(completion: { (error) in
                        if error != nil {
                            print(error)
                            
                        }else {
                            
                            Auth.auth().signIn(withEmail: "managergene" + self.emailDummy, password: self.password, completion: { (result, error) in
                                if error != nil {
                                    print(error)
                                }else {
                                    
                                    self.announceDeletion(FirstName: FirstName, LastName: LastName, UnitorPosition: UnitorPosition)
                                }
                            })
                        }
                    })
                    
                }
            })
            
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            Auth.auth().signIn(withEmail: "managergene"+self.emailDummy, password: self.password, completion: { (result, error) in
                if error != nil {
                    print(error)
                }else{
                    print("success")
                }
            })
            
        }
        
        deletecontroller.addAction(cancel)
        deletecontroller.addAction(deleteaction)
        present(deletecontroller, animated: true, completion: nil)
        
    }
    
    func announceDeletion(FirstName:String, LastName:String, UnitorPosition:String ){
        
        let announceController = UIAlertController(title: "Would you like to Announce \(FirstName) \(LastName) with be leaving us?", message: nil, preferredStyle:  .alert)
        let announceAction = UIAlertAction(title: "Announce", style: .default) { (alert) in
            
            
            let announceMessage = "\(FirstName) \(LastName) from unit \(UnitorPosition) will be leaving us.."
            
            //creating reference in database for messages
            let Childref =  Database.database().reference().child("groupmessages").childByAutoId()
            
            
            //current user id
            let fromid = Auth.auth().currentUser!.uid
            
            //setting a date as time stamp
            let timeStamp = NSDate().timeIntervalSince1970 as NSNumber
            let values = ["text" : announceMessage, "fromid" : fromid, "timestamp" : timeStamp, "type" : "announce"] as [String : Any]
            
            //empty text when send is clicked
            
            
            //send in the values to  database
            Childref.updateChildValues(values) { (error, ref) in
                if error != nil{
                    print(error)
                }
            
            
            }}
        let cancel = UIAlertAction(title: "Dont Announce", style: .cancel) { (alert) in
            Auth.auth().signIn(withEmail: "managergene"+self.emailDummy, password: self.password, completion: { (result, error) in
                if error != nil {
                    print(error)
                }else{
                    print("success")
                }
            })
        }
        
        announceController.addAction(cancel)
        announceController.addAction(announceAction)
        present(announceController, animated: true, completion: nil)
        
    }
    
    
    func updateuser(FirstName: String, LastName: String, UnitorPosition: String) {
        updatedTenantandStaffTextFields.removeAll()
        
        let updateuseralertcontroller = UIAlertController(title: "Update Tenant Info", message: nil, preferredStyle: .alert)
        updateuseralertcontroller.addTextField { (firstNameTextField) in
            firstNameTextField.placeholder = "First Name.."
            firstNameTextField.borderStyle = .roundedRect
            firstNameTextField.text = FirstName
            self.updatedFirstNameTextField = firstNameTextField
        }
        
        updateuseralertcontroller.addTextField { (lastNameTextField) in
            lastNameTextField.placeholder = "Last Name.."
            lastNameTextField.borderStyle = .roundedRect
            lastNameTextField.text = LastName
            self.updatedLastNameTextField = lastNameTextField
        }
        
        updateuseralertcontroller.addTextField { (unitandPositionTextField) in
            unitandPositionTextField.placeholder = "Enter"
            unitandPositionTextField.borderStyle = .roundedRect
            unitandPositionTextField.text = UnitorPosition
            self.updatedUnitandPositionTextField = unitandPositionTextField
            
        }
        
        
        let update = UIAlertAction(title: "Update", style: .default) { (alert) in
            
            self.updatedTenantandStaffTextFields.append((self.updatedFirstNameTextField.text?.capitalized)!)
            self.updatedTenantandStaffTextFields.append((self.updatedLastNameTextField.text?.capitalized)!)
            self.updatedTenantandStaffTextFields.append((self.updatedUnitandPositionTextField.text?.capitalized)!)
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            
            Auth.auth().currentUser?.updateEmail(to: self.updatedTenantandStaffTextFields[0]+self.updatedTenantandStaffTextFields[1]+self.emailDummy, completion: { (error) in
                
                if error != nil {
                    self.handleError(error!)
                }else {
                
                let ref = Database.database().reference().child("Users").child(uid)
                let values: [String : Any] = ["FirstName" : self.updatedTenantandStaffTextFields[0], "LastName" : self.updatedTenantandStaffTextFields[1], "Unit" : self.updatedTenantandStaffTextFields[2]]
                
                ref.updateChildValues(values, withCompletionBlock: { (error, reference) in
                    if error != nil {
                        print(error)
                    }else {
                       
                        do{
                        try Auth.auth().signOut()
                        }catch{
                            if error != nil {
                                print(error)
                            }
                            
                        }
                        
                        Auth.auth().signIn(withEmail: "managergene"+self.emailDummy, password: self.password, completion: { (result, error) in
                            if error != nil {
                                print(error)
                            }else {
                                print("success")
                            }
                            
                        })
                    }
                })
                } })
            
            
          
            }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            Auth.auth().signIn(withEmail: "managergene"+self.emailDummy, password: self.password, completion: { (result, error) in
                if error != nil {
                    print(error)
                }else{
                    print("success")
                }
            })
        }
        
        
        updateuseralertcontroller.addAction(update)
        updateuseralertcontroller.addAction(cancel)
        present(updateuseralertcontroller, animated: true, completion: nil)
        
    }

}

