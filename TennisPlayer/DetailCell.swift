//
//  DetailCell.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2018/12/28.
//  Copyright © 2018 Junwei Hu. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
