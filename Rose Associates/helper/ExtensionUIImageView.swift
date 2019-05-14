//
//  ExtensionUIImageView.swift
//  Rose Associates
//
//  Created by user145580 on 5/3/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit
//creating reference to NSCache to store images
let imageCatch = NSCache<NSString, UIImage>()

extension UIImageView {
    
   
    //creating function
    func loadImageUsingCache(urlString: String){
        
            //getting reference to stored images in cache
        if let cacheImage = imageCatch.object(forKey: urlString as NSString){
            
            //set image to chite color beforeloaded
            self.image = nil
            
            //get image from stored reference after it was saved
            self.image = cacheImage
            return
        }
        
        //getting url for image session
        let url = URL(string: urlString)
        
        //URL session for image url
        let imageURLSession = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("there was a error fetching pic", error)
                
                return
                
            }else {
                
                
                DispatchQueue.main.async {
                    //assinging downloaded image from URL
                    if let downloadedImage = UIImage(data: data!) {
                        
                        //storing downloaded image in image cache with key as url string
                        imageCatch.setObject(downloadedImage, forKey: urlString as NSString)
                        
                        //setting the image to downloaded image
                        self.image = downloadedImage
                    }
                   
                }
                
                
                
                
            }
            //resuming session in ordr for it to work
        };imageURLSession.resume()
        
    }
    
}

