//
//  SellerViewCellTableViewCell.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/6/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class SellerViewCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restName: UILabel?
    @IBOutlet weak var minLeft: UILabel?
    @IBOutlet weak var price: UILabel?
    @IBOutlet weak var realPrice: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
