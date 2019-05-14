//
//  Extentionfirebaseerror.swift
//  Rose Associates
//
//  Created by user145580 on 5/11/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
import Firebase

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "That user already exist"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid name"
        case .networkError:
            return "Network error. Please try again."
        default:
            return "Unknown error occurred"
        }
    }
}



extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
