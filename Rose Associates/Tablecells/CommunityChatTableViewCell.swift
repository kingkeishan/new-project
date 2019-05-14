//
//  CommunityChatTableViewCell.swift
//  Rose Associates
//
//  Created by user145580 on 4/23/19.
//  Copyright © 2019 Keishan Rodriguez. All rights reserved.
//

import UIKit

class CommunityChatTableViewCell: UITableViewCell {

    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var TextLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ProfilePic.layer.cornerRadius = ProfilePic.frame.width / 2
        ProfilePic.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
