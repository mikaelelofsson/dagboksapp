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
   // var imageName: String

    
    
    //Mark: -Firebase Keys
    
    enum EntryKey {
        static let timeStamp = "date"
        static let entryText = "entryText"
    }
   
    init?() {
        self.init(postId: "", entryText: "", timeStamp: 0)
    }
    
    
    init(postId:String, entryText:String, /*imageName:String,*/ timeStamp: Int = Int(NSDate().timeIntervalSince1970 * 1000)){
        self.postId = postId
        self.entryText = entryText
        //self.imageName=imageName
        self.timeStamp = timeStamp
    }
    
    init?(postId:String, postInfo:[String:Any]) {
       guard let entryText = postInfo[EntryKey.entryText] as? String,
    let timeStamp = postInfo[EntryKey.timeStamp] as? Int
        else {
            return nil
        }
        
        self = DiaryEntry(postId: postId, entryText: entryText, timeStamp: timeStamp)
    }
    
    
    
}
