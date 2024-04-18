//
//  TableViewCell.swift
//  WishList
//
//  Created by Sam.Lee on 4/16/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var  idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
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
