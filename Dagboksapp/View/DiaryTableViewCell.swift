//
//  DiaryTableViewCell.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-26.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    

    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView! /*{
        didSet {
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width/2
            thumbnailImageView.clipsToBounds = true
        }
    }*/
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
