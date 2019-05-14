//
//  NewMessageCell.swift
//  Rose Associates
//
//  Created by user145580 on 4/28/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {

    
    @IBOutlet weak var CelIImage: UIImageView!
    
    @IBOutlet weak var TimeStamp: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var TextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TimeStamp.translatesAutoresizingMaskIntoConstraints = false
        TimeStamp.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        TimeStamp.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20).isActive = true
      //  TimeStamp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        TimeStamp.font = UIFont(name: "Helvetica-Light", size: 12.5)
        TimeStamp.textColor = .lightGray
        
        
        let view = UIView()
        view .backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 26
        view.clipsToBounds = true
        contentView.addSubview(view)
        
        view.widthAnchor.constraint(equalToConstant: 52).isActive = true
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        view.addSubview(CelIImage)
        
        
        CelIImage.translatesAutoresizingMaskIntoConstraints = false
        CelIImage.image = UIImage(named: "BlankProfilePic.jpg")
        CelIImage.layer.cornerRadius = 25
        CelIImage.clipsToBounds = true
        
        
        CelIImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        CelIImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        CelIImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
       // CelIImage.leftAnchor.constraint(equalTo: .leftAnchor, constant: 20).isActive = true
        CelIImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        NameLabel.translatesAutoresizingMaskIntoConstraints = false
        NameLabel.textColor = .lightGray
        NameLabel.font = UIFont(name: "Helvetica-Light", size: 20)
        
        NameLabel.leftAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        //NameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        NameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        
        
        
        TextLabel.translatesAutoresizingMaskIntoConstraints = false
        TextLabel.textColor = .black
        TextLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
        
        
        
        TextLabel.leftAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        //TextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        TextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10).isActive = true
        
        
        
    }

    
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
