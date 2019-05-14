//
//  TenantsManagementTableViewCell.swift
//  Rose Associates
//
//  Created by user145580 on 4/17/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit

class TenantsManagementTableViewCell: UITableViewCell {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.blue : UIColor.white
            print(isHighlighted)
        }
    }
 

    @IBOutlet weak var CelIImage: UIImageView!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var UnitLabel: UILabel!
    
    
    
        override func awakeFromNib() {
        super.awakeFromNib()
           
         
            
         
            
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
            CelIImage.contentMode = .scaleAspectFill
            
            
           CelIImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
           
          CelIImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
            CelIImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
            CelIImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
           
            
            NameLabel.translatesAutoresizingMaskIntoConstraints = false
            NameLabel.textColor = .lightGray
            NameLabel.font = UIFont(name: "Helvetica-Light", size: 15)
           
            
            NameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            NameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
            
            
           
            UnitLabel.translatesAutoresizingMaskIntoConstraints = false
            UnitLabel.textColor = .black
            UnitLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
           
            
            
            UnitLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            UnitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10).isActive = true
            
            
    
           
            
            
            
                }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

    
    

}
