//
//  DiaryTableViewCell.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-26.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    
    var currentEntry: DiaryEntry?
    
    
   
    
    @IBOutlet weak var cellView: UIView!{
        didSet {
            
            cellView.layer.cornerRadius = cellView.bounds.height/11
            cellView.clipsToBounds = true
            
                    cellView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                    cellView.layer.shadowOffset = CGSize(width: 0, height: 1.2)
                    cellView.layer.shadowOpacity = 0.2
                    cellView.layer.shadowRadius = 0
                    cellView.layer.masksToBounds = false
            
        }
    }
    @IBOutlet weak var mainView: UIView! {
        didSet {
          self.mainView.backgroundColor = UIColor(white:1, alpha:0)
        }
    }
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = cellView.layer.cornerRadius
            thumbnailImageView.clipsToBounds = true
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
    
    func configure (entry: DiaryEntry) {
        
        currentEntry = entry
        selectionStyle = .none
        entryLabel.text = entry.birdName
        previewLabel.text = entry.date
        
        thumbnailImageView.image = nil
        
        //Download image
        if let image = CacheManager.shared.getFromCache(key: entry.imageURL) as? UIImage {
            thumbnailImageView.image = image
        } else {
            
            if let url = URL(string: entry.imageURL), entry.imageURL != "saknas" {
                let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                    
                    guard let imageData = data else {
                        return
                    }
                    
                    OperationQueue.main.addOperation {
                        guard let image = UIImage(data: imageData) else {
                            return
                        }
                        
                        if self.currentEntry?.imageURL == entry.imageURL {
                        self.thumbnailImageView.image = image
                        }
                        
                        CacheManager.shared.cache(object: image, key: entry.imageURL)
                    }
                })
                
                downloadTask.resume()
            }
           
        }
    }

}
