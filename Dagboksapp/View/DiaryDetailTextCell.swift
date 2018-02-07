//
//  DiaryDetailTextCell.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-29.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit

class DiaryDetailTextCell: UITableViewCell {

    @IBOutlet weak var entryText: UILabel! {
        didSet {
            entryText.numberOfLines = 0
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
