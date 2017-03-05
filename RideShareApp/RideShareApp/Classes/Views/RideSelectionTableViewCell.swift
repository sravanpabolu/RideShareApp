//
//  RideSelectionTableViewCell.swift
//  RideShareApp
//
//  Created by Kanya Rajan on 3/5/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import UIKit

class RideSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRideDtl: UILabel!
    @IBOutlet weak var lblRouteName: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
