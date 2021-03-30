//
//  ButtonsCell.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/29/21.
//

import UIKit

class ButtonsCell: UITableViewCell {

    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
