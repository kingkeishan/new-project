//
//  SplashVeiwController.swift
//  Rose Associates
//
//  Created by user145580 on 4/13/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import RevealingSplashView
import Firebase


class SplashVeiwController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    
// Content View Width and pages width
    @IBOutlet weak var ContentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var ChooseLanguageWidth: NSLayoutConstraint!
    @IBOutlet weak var ChooseProfilePictureWidth: NSLayoutConstraint!
    @IBOutlet weak var ChooseBirthdayWidth: NSLayoutConstraint!
    @IBOutlet weak var EnterBioWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var ContentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    //Front Views
    @IBOutlet weak var ChooseLanguageView: UIView!
    @IBOutlet weak var ChooseBirthdayView: UIView!

    @IBOutlet weak var ChooseProfilePic: UIView!

    @IBOutlet weak var EnterBoiView: UIView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var viewForLanguageText: UIView!
    
    //page view next buttons
    @IBOutlet weak var ProfilePicNextButton: UIButton!
    @IBOutlet weak var chooseLanguageNextButton: UIButton!
    @IBOutlet weak var chooseBirthdayNextButton: UIButton!
    
    @IBOutlet weak var ChooseProfileImage: UIButton!
    
    @IBOutlet weak var BioContinueButtom: UIButton!
    

    
    @IBOutlet weak var ProfilePic: UIImageView!
    
    
    //Textfields and Pickers
    @IBOutlet weak var BirthdayTextField: UITextField!
    @IBOutlet weak var BirthdayDatePicker: UIDatePicker!
 
    @IBOutlet weak var LanguageTextField: UITextField!
    
    
    @IBOutlet weak var EnterBioTextView: UITextView!
    
    
    
    
    
    var arrayForPickerComponent1 = ["01"]
    var arrayForPickerComponent0 = ["Januray"]
    
    let monthsArray = ["January", "february", "march", "april", "may", "june", "july", "august", "september", "november", "december" ]
    var days = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    
    var feb = Bool()
    var april = Bool()
    var june = Bool()
    var sep = Bool()
    var nov = Bool()
    let borderMinusPic: CGFloat = 20
    
    let LanguageArray = ["Enlgish", "Spanish" , "Chinese", "Japanese", "Korean", "French"]
    
    
    
    
    
    
    
    
    var BackBarButton: UIBarButtonItem {
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BacktoPrevious))
    back.tintColor = UIColor(red: 20/255, green: 170/255, blue: 192/255, alpha: 1)
        
        return back
    }
    
    var LanguagePicker: UIPickerView {
        var picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: view.frame.height, width: ChooseLanguageWidth.constant, height: 200)
        picker.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        picker.showsSelectionIndicator = false
        picker.delegate = self
        picker.dataSource = self
        return picker
    }
    
    var CustomPickerViewForDate: UIPickerView {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: view.frame.height, width: ContentViewWidth.constant, height: 200)
        picker.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244, alpha: 1)
        picker.showsSelectionIndicator = false
       picker.delegate = self
       picker.dataSource = self
        
        return picker
    }
    
    
    
   


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        LanguageTextField.translatesAutoresizingMaskIntoConstraints = false
        LanguageTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        LanguageTextField.widthAnchor.constraint(equalTo: chooseLanguageNextButton.widthAnchor).isActive = true
        LanguageTextField.centerXAnchor.constraint(equalTo: ChooseLanguageView.centerXAnchor).isActive = true
        LanguageTextField.topAnchor.constraint(equalTo: ChooseLanguageView.topAnchor, constant: 250).isActive = true
        
        BirthdayTextField.translatesAutoresizingMaskIntoConstraints = false
        BirthdayTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        BirthdayTextField.widthAnchor.constraint(equalTo: chooseBirthdayNextButton.widthAnchor).isActive = true
        BirthdayTextField.centerXAnchor.constraint(equalTo: ChooseBirthdayView.centerXAnchor).isActive = true
        BirthdayTextField.topAnchor.constraint(equalTo: ChooseBirthdayView.topAnchor, constant: 250).isActive = true
        
        
        EnterBioTextView.translatesAutoresizingMaskIntoConstraints = false
        EnterBioTextView.centerXAnchor.constraint(equalTo: EnterBoiView.centerXAnchor).isActive = true
        EnterBioTextView.widthAnchor.constraint(equalTo: LanguageTextField.widthAnchor).isActive = true
        EnterBioTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        EnterBioTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        EnterBioTextView.layer.cornerRadius = 5
        EnterBioTextView.clipsToBounds = true
        EnterBioTextView.font = UIFont.boldSystemFont(ofSize: 16)
        EnterBioTextView.textColor = .white
       
      
        ChooseLanguageView.addSubview(LanguagePicker)
        
        ChooseBirthdayView.addSubview(CustomPickerViewForDate)
        
        
        // Setting width of all pages to fit
        ContentViewWidth.constant = self.view.frame.width * 4
        ChooseLanguageWidth.constant = self.view.frame.width
        ChooseProfilePictureWidth.constant = self.view.frame.width
        ChooseBirthdayWidth.constant = self.view.frame.width
        EnterBioWidth.constant = self.view.frame.width
        
        //setting height of ContentView
        ContentViewHeight.constant = self.view.frame.height
        
      ProfilePicNextButton.layer.cornerRadius = 5
        
        ProfilePicNextButton.titleLabel?.text = "Next"
        ProfilePicNextButton.clipsToBounds = true
        ProfilePicNextButton.translatesAutoresizingMaskIntoConstraints = false
        ProfilePicNextButton.centerXAnchor.constraint(equalTo: ProfilePic.centerXAnchor).isActive = true
        ProfilePicNextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        ProfilePicNextButton.widthAnchor.constraint(equalToConstant: 255).isActive = true
        ProfilePicNextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        ProfilePicNextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
  LanguageTextField.inputView = LanguagePicker
   BirthdayTextField.inputView = CustomPickerViewForDate
        BirthdayTextField.delegate = self
        
        
        ProfilePic.layer.cornerRadius = 5
        ProfilePic.layer.masksToBounds = true
        ProfilePic.translatesAutoresizingMaskIntoConstraints = false
        ProfilePic.centerXAnchor.constraint(equalTo: ChooseProfilePic.centerXAnchor).isActive = true
        ProfilePic.widthAnchor.constraint(equalToConstant: ChooseProfilePictureWidth.constant).isActive = true
        ProfilePic.heightAnchor.constraint(equalToConstant: 250).isActive = true
        ProfilePic.topAnchor.constraint(equalTo: ChooseProfilePic.topAnchor, constant: 75).isActive = true
      
        chooseLanguageNextButton.layer.cornerRadius = 5
        chooseLanguageNextButton.titleLabel?.text = "Next"
        chooseLanguageNextButton.clipsToBounds = true
        chooseLanguageNextButton.translatesAutoresizingMaskIntoConstraints = false
        chooseLanguageNextButton.centerXAnchor.constraint(equalTo: ChooseLanguageView.centerXAnchor).isActive = true
        chooseLanguageNextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        chooseLanguageNextButton.widthAnchor.constraint(equalToConstant: ChooseLanguageWidth.constant - 24).isActive = true
        chooseLanguageNextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        chooseLanguageNextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
     
        
        chooseBirthdayNextButton.layer.cornerRadius = 5
        chooseBirthdayNextButton.titleLabel?.text = "Next"
        chooseBirthdayNextButton.clipsToBounds = true
        chooseBirthdayNextButton.translatesAutoresizingMaskIntoConstraints = false
        chooseBirthdayNextButton.centerXAnchor.constraint(equalTo: ChooseBirthdayView.centerXAnchor).isActive = true
        chooseBirthdayNextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        chooseBirthdayNextButton.widthAnchor.constraint(equalToConstant: ChooseBirthdayWidth.constant - 24).isActive = true
        chooseBirthdayNextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        chooseBirthdayNextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        
        ChooseProfileImage.layer.cornerRadius = 5
        ChooseProfileImage.titleLabel?.text = "Next"
        ChooseProfileImage.clipsToBounds = true
        ChooseProfileImage.translatesAutoresizingMaskIntoConstraints = false
        ChooseProfileImage.centerXAnchor.constraint(equalTo: ChooseProfilePic.centerXAnchor).isActive = true
        ChooseProfileImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        ChooseProfileImage.widthAnchor.constraint(equalToConstant: 255).isActive = true
        ChooseProfileImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        ChooseProfileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
     
        
        BioContinueButtom.layer.cornerRadius = 5
        BioContinueButtom.titleLabel?.text = "Done"
        BioContinueButtom.clipsToBounds = true
        BioContinueButtom.translatesAutoresizingMaskIntoConstraints = false
        BioContinueButtom.centerXAnchor.constraint(equalTo: EnterBioTextView.centerXAnchor).isActive = true
        BioContinueButtom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        BioContinueButtom.widthAnchor.constraint(equalTo: EnterBioTextView.widthAnchor).isActive = true
        BioContinueButtom.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        BioContinueButtom.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
       
        
        viewForLanguageText.translatesAutoresizingMaskIntoConstraints = false
        viewForLanguageText.layer.cornerRadius = 5
        viewForLanguageText.clipsToBounds = true
        viewForLanguageText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        viewForLanguageText.centerYAnchor.constraint(equalTo: LanguageTextField.centerYAnchor).isActive = true
        viewForLanguageText.centerXAnchor.constraint(equalTo: LanguageTextField.centerXAnchor).isActive = true
        viewForLanguageText.widthAnchor.constraint(equalTo: LanguageTextField.widthAnchor).isActive = true
        
   
        
      
        
      
   
        
    }
   
  
    
  @objc func birthdayviewclick () {
        BirthdayTextField.resignFirstResponder()
    }
    
    
    
    
    
    //confuguring the back button
    @objc func BacktoPrevious() {
        //changin screen positon to croll back
        let screenPosition = CGPoint(x:ScrollView.contentOffset.x - ChooseLanguageWidth.constant, y: 0)
        BirthdayTextField.resignFirstResponder()
        
        ScrollView.setContentOffset(screenPosition, animated: true)
        if ScrollView.contentOffset.x == ChooseLanguageWidth.constant {
            self.navigationController?.title = "Choose Your Language"
            self.navigationItem.setLeftBarButton(nil, animated: true)
            navigationItem.title = "Choose Your Language"
        }
        if ScrollView.contentOffset.x == ChooseLanguageWidth.constant * 2 {
            navigationItem.title = "Whats your Birthday"
        }
        if ScrollView.contentOffset.x == ChooseLanguageWidth.constant * 3 {
            navigationItem.title = "Choose A Profile Pic"
        }
        
    }
    //Confuguring Image Picker
    @IBAction func CooseProfileImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let ChoosingCamera = UIAlertAction(title: "Camera", style: .default) { (Alert) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)        }
        
        
        let ChoosingPhoto = UIAlertAction(title: "PhotoLibary", style: .default) { (alert) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ChoosingCamera)
        alert.addAction(ChoosingPhoto)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    //when the imagePicker pick the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //getting the edited image if edited
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            ProfilePic.image = image
        } else {
            
            //getting the original image
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            ProfilePic.image = image
                
                }
        
    
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //cancelling imagePicker if cancel was clicked
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ChooselanguageButton(_ sender: Any) {
        navigationItem.title = " Whats Your Birthday"
        let screenPosition = CGPoint(x: self.view.frame.width, y: 0)
        ScrollView.setContentOffset(screenPosition, animated: true)
        LanguageTextField.resignFirstResponder()
        self.navigationItem.setLeftBarButton(BackBarButton, animated: true)
    }
    @IBAction func ChooseBirthdayButton(_ sender: Any) {
        navigationItem.title = "Choose A Profile Pic"
        let screenPosition = CGPoint(x: self.view.frame.width * 2, y: 0)
        ScrollView.setContentOffset(screenPosition, animated: true)
        BirthdayTextField.resignFirstResponder()
    }
    
    @IBAction func ChooseProfilePicButton(_ sender: Any) {
        navigationItem.title =  "Write A Bio"
        let screenPosition = CGPoint(x: self.view.frame.width * 3, y: 0)
        ScrollView.setContentOffset(screenPosition, animated: true)    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == BirthdayTextField.inputView {
            return 2
        }else{
        return 1
        }}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == BirthdayTextField.inputView {
            if component == 1 {
                if feb {
                
                    return 28
                }
                if april {
                    return 30
                }
                if june {
                    return 30
                }
                if sep {
                    return 30
                }
                if nov {
                    return 20
                }
                return days.count
                
            }
            return monthsArray.count
        }
        if pickerView == LanguageTextField.inputView {
            return LanguageArray.count }
        return 1
    }
    
   
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //if birthday picker
        if pickerView == BirthdayTextField.inputView {
            
            //if component on days
            if component == 1 {
                return days[row]
            }
           return monthsArray[row]
        
        }
        if pickerView == LanguageTextField.inputView {
            return LanguageArray[row]
            
        }
        return "error"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == BirthdayTextField.inputView {
            pickerView.reloadComponent(1)
        
    if pickerView.selectedRow(inComponent: 0) == 1 {
            feb = true
            april = false
            june = false
            sep = false
            nov = false
            pickerView.reloadComponent(1)
        }
        else if pickerView.selectedRow(inComponent: 0) == 3 {
            april = true
            feb = false
            june = false
            sep = false
            nov = false
            pickerView.reloadComponent(1)
        }
        else if pickerView.selectedRow(inComponent: 0) == 5 {
            june = true
            feb = false
            april = false
            sep = false
            nov = false
            pickerView.reloadComponent(1)
        }
        else if pickerView.selectedRow(inComponent: 0) == 8 {
            sep = true
            june = false
            feb = false
            april = false
            nov = false
            pickerView.reloadComponent(1)
        }
        else if pickerView.selectedRow(inComponent: 0) == 10 {
            nov = true
            june = false
            feb = false
            april = false
            sep = false
            pickerView.reloadComponent(1)
        }else {
            nov = false
            june = false
            feb = false
            april = false
            sep = false
            pickerView.reloadComponent(1)
        }
       
        if pickerView.selectedRow(inComponent: 1) == component {
        
    
        }
        if component == 1 {
            arrayForPickerComponent1.removeAll()
            arrayForPickerComponent1.append(days[row])
            
            
        }
        if component == 0 {
            arrayForPickerComponent0.removeAll()
            arrayForPickerComponent0.append(monthsArray[row])
        }
            BirthdayTextField.text = arrayForPickerComponent0[0] + " " + arrayForPickerComponent1[0] }
        if pickerView == LanguageTextField.inputView {
        
            LanguageTextField.text = LanguageArray[row] }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    @IBAction func LogOut(_ sender: Any) {
        do {
        try Auth.auth().signOut()
        }catch {
            
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @IBAction func completedContinueButton(_ sender: Any) {
        
        
        
        //Uploading Pic to data base
        let image = NSUUID().uuidString
        let storageref = Storage.storage().reference().child("\(image).jpg")
        if let uploadData = ProfilePic.image?.jpegData(compressionQuality: 0.1){
            
            storageref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                }else {
                    
                    storageref.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error)
                            return
                        }else {
                            print(url?.absoluteString)
                            if let uid = Auth.auth().currentUser?.uid {
                                
                            let ref = Database.database().reference().child("Users").child(uid)
                                let values = ["Bio" : self.EnterBioTextView.text, "Birthday" : self.BirthdayTextField.text, "Language" : self.LanguageTextField.text, "ProfilePic" : url?.absoluteString]
                                
                                ref.updateChildValues(values, withCompletionBlock: { (error, reference) in
                                    
                                    
                                    
                                })
                            }
                            
                        }
                    })
                    
                }
            }
        }
        
    }
    
   
    
}
