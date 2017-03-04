//
//  RouteTableViewCell.swift
//  RideShareApp
//
//  Created by Kanya Rajan on 3/4/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRouteName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
