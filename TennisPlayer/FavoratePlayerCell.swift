//
//  FavoratePlayerCell.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/27.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit

class FavoratePlayerCell: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
