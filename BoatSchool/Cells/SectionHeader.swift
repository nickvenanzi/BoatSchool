//
//  sectionHeader.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 4/6/21.
//

import UIKit

class SectionHeader: UITableViewCell {

   
    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
