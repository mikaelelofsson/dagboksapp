//
//  PostService.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-31.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseStorage

final class PostService {
    //Mark: -Properties
    
//    static var globalEntryArray: [DiaryEntry]!
    static let shared: PostService = PostService()
    let date = Date()
    let formatter = DateFormatter()
    
    private init() {}
    
    let BASE_DB_REF: DatabaseReference = Database.database().reference()
    let POST_DB_REF: DatabaseReference = Database.database().reference().child("entries")
    let IMG_STORAGE_REF: StorageReference = Storage.storage().reference().child("photos")
    
    
    //MARK: -Firebase Upload and Download Methods
    
    
    
    func uploadDiaryEntry(entryObject: DiaryEntry, imageData: Data?, completionHandler: @escaping(Bool) -> Void) -> Void {
        
        var imageFileURL: String! = "saknas"
        
        let postDatabaseRef = POST_DB_REF.childByAutoId()
        let imgStorageRef = IMG_STORAGE_REF.child("\(postDatabaseRef.key).jpg")
        
        formatter.dateFormat = "YYYY-MM-dd"
        //UPLOAD IMAGE
        
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        if imageData != nil {
        let uploadTask = imgStorageRef.putData(imageData as Data!, metadata:uploadMetadata)
            
            uploadTask.observe(.success) { (snapshot) in
                imageFileURL = snapshot.metadata?.downloadURL()?.absoluteString
                
                //        let today = formatter.string(from: date)
                let timestamp = Int64(NSDate().timeIntervalSince1970 * 1000)
                let entry: [String : Any] = ["entryText" : entryObject.entryText,
                                             "timeStamp" : timestamp,
                                             "recordingName" : entryObject.recordingName,
                                             "date": entryObject.date,
                                             "birdName" : entryObject.birdName,
                                             "imageFileURL": imageFileURL,
                                             "latitude": entryObject.locationLat,
                                             "longitude":entryObject.locationLon]
                
                postDatabaseRef.setValue(entry)
                completionHandler(true)
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                print("Uploading... \(percentComplete)% complete")
            }
            
            uploadTask.observe(.failure) { (snapshot) in
                let alertMessage = UIAlertController(title: "Felmeddelande", message: "Någonting gick fel när inlägget skulle sparas. Var god försök igen om en stund", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
        } else {
        
            let timestamp = Int64(NSDate().timeIntervalSince1970 * 1000)
            let entry: [String : Any] = ["entryText" : entryObject.entryText,
                                         "timeStamp" : timestamp,
                                         "recordingName" : entryObject.recordingName,
                                         "date": entryObject.date,
                                         "birdName" : entryObject.birdName,
                                         "imageFileURL": imageFileURL,
                                         "latitude": entryObject.locationLat,
                                         "longitude":entryObject.locationLon]
            postDatabaseRef.setValue(entry)
            completionHandler(true)        }
    }
    
    func downloadLatestEntries(startTime startTimestamp: Int? = nil, limit: UInt, completionHandler: @escaping([DiaryEntry]) ->Void) {
        
       
        //Create the query
        var postQuery = POST_DB_REF.queryOrdered(byChild: DiaryEntry.EntryKey.timeStamp)
        
        //If a timestamp is passed to the function, we will get the posts that has a timestamp that is newer than the given value
        if let latestPostTimestamp = startTimestamp, latestPostTimestamp > 0 {
        
            postQuery = postQuery.queryStarting(atValue:latestPostTimestamp + 1, childKey: DiaryEntry.EntryKey.timeStamp).queryLimited(toLast:limit)
        }
            //Otherwise we will just get the most recent posts
        else {
            postQuery = postQuery.queryLimited(toLast:limit)
        }
        
       postQuery.observeSingleEvent(of: .value, with: {(snapshot) in
        
        var newEntries:[DiaryEntry] = []
        
        for item in snapshot.children.allObjects as! [DataSnapshot]{
            
            let postData = item.value as? [String : Any] ?? [:]
            
            if let post = DiaryEntry(postId: item.key, postInfo: postData){
                newEntries.append(post)
                print(post.imageURL)
            }
        }
        
        //Order the array so that the most recent entry becomes the first post in the array
        
        if newEntries.count > 0 {
            newEntries.sort(by: {$0.timeStamp > $1.timeStamp})
        }
    
       completionHandler(newEntries)
            })
        }

    
     func getOldEntries(startTime startTimestamp: Int, limit: UInt, completionHandler: @escaping([DiaryEntry]) ->Void) {
    
        var postQuery = POST_DB_REF.queryOrdered(byChild:DiaryEntry.EntryKey.timeStamp)
        
        postQuery = postQuery.queryEnding(atValue: startTimestamp - 1, childKey: DiaryEntry.EntryKey.timeStamp).queryLimited(toLast:limit)
        
        
        postQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            
            var newEntries: [DiaryEntry] = []
            
            for item in snapshot.children.allObjects as! [DataSnapshot] {
             let entryData = item.value as? [String: Any] ?? [:]
                
                if let entry = DiaryEntry(postId:item.key, postInfo:entryData){
                
                newEntries.append(entry)
            }
        }
        
            newEntries.sort(by: { $0.timeStamp > $1.timeStamp })
            
            completionHandler(newEntries)

        })

        
    }
}
    


