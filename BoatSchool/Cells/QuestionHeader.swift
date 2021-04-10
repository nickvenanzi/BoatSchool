//
//  QuestionHeaderTableViewCell.swift
//  BoatSchool
//
//  Created by Nick Venanzi on 4/9/21.
//

import UIKit

class QuestionHeader: UITableViewCell {

    @IBOutlet var questionImage: UIImageView!
    
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
