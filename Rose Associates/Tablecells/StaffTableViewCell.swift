//
//  StaffTableViewCell.swift
//  Rose Associates
//
//  Created by user145580 on 4/19/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit

class StaffTableViewCell: UITableViewCell {
    

    
    @IBOutlet weak var StaffCellImage: UIImageView!
    @IBOutlet weak var StaffNameLabel: UILabel!
    @IBOutlet weak var PositionLabel: UILabel!
    

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
        
        
        view.addSubview(StaffCellImage)
        
        
        StaffCellImage.translatesAutoresizingMaskIntoConstraints = false
        StaffCellImage.image = UIImage(named: "BlankProfilePic.jpg")
        StaffCellImage.layer.cornerRadius = 25
        StaffCellImage.clipsToBounds = true
        
        
        StaffCellImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        StaffCellImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        StaffCellImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        StaffCellImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        StaffNameLabel.translatesAutoresizingMaskIntoConstraints = false
        StaffNameLabel.textColor = .lightGray
        StaffNameLabel.font = UIFont(name: "Helvetica-Light", size: 15)
        
        
        StaffNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        StaffNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        
        
        
        PositionLabel.translatesAutoresizingMaskIntoConstraints = false
        PositionLabel.textColor = .black
        PositionLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        
        
        
        PositionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        PositionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10).isActive = true
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       

        // Configure the view for the selected state
    }
    
    

}
