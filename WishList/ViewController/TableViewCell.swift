//
//  TableViewCell.swift
//  WishList
//
//  Created by 서혜림 on 4/17/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    static let identifier = "TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
