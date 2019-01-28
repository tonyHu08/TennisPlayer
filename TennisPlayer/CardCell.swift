//
//  CardCell.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2018/12/27.
//  Copyright © 2018 Junwei Hu. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var ChineseNameLabel: UILabel!
    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var favorate = false {
        willSet {
            if newValue {
                favBtn.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
            } else {
                favBtn.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
