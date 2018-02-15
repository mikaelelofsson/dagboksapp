//
//  DiaryEntry.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-29.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import Foundation

struct DiaryEntry {
    
    //MARK: -Properties
    
    var postId: String
    var entryText: String
    var timeStamp: Int
    var recordingName: String
    var imageURL: String
    var locationLat: Double
    var locationLon: Double
    var birdName: String?
    var date: String
    
   // var imageName: String

    
    
    //Mark: -Firebase Keys
    
    enum EntryKey {
        static let timeStamp = "timeStamp"
        static let entryText = "entryText"
        static let recordingName = "recordingName"
        static let imageFileURL = "imageFileURL"
        static let locationLat = "latitude"
        static let locationLon = "longitude"
        static let birdName = "birdName"
        static let date = "date"
    }
   
    init?() {
        self.init(postId: "",
                  recordingName: "",
                  date: "",
                  birdName: "",
                  imageURL: "",
                  entryText: "",
                  locationLon: 0,
                  locationLat: 0,
                  timeStamp: 0)
    }
    
    
    init(postId:String,
         recordingName:String,
         date: String,
         birdName: String,
         imageURL: String,
         entryText:String,
         locationLon:Double,
         locationLat:Double,
         timeStamp: Int = Int(NSDate().timeIntervalSince1970 * 1000))
    {
        self.postId = postId
        self.entryText = entryText
        self.timeStamp = timeStamp
        self.recordingName = recordingName
        self.imageURL = imageURL
        self.locationLon = locationLon
        self.locationLat = locationLat
        self.birdName = birdName
        self.date = date
    }
    
    init?(postId:String,
          postInfo:[String:Any])
    {
       guard let entryText = postInfo[EntryKey.entryText] as? String,
        let timeStamp = postInfo[EntryKey.timeStamp] as? Int,
        let recordingName = postInfo[EntryKey.recordingName] as? String,
        let imageURL = postInfo[EntryKey.imageFileURL] as? String,
        let locationLon = postInfo[EntryKey.locationLon] as? Double,
        let locationLat = postInfo[EntryKey.locationLat] as? Double,
        let birdName = postInfo[EntryKey.birdName] as? String,
        let date = postInfo[EntryKey.date] as? String
        else {
            return nil
        }
        
        self = DiaryEntry(postId: postId,
                          recordingName: recordingName,
                          date: date,
                          birdName: birdName,
                          imageURL: imageURL,
                          entryText: entryText,
                          locationLon: locationLon,
                          locationLat: locationLat,
                          timeStamp: timeStamp)
    }
    

    
    
    
}
