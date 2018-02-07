//
//  CreateEntryController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-30.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit
import Firebase

class CreateEntryController: UIViewController {
    
    @IBOutlet weak var dayName: UILabel!

    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var year: UILabel!
    var databaseRef: DatabaseReference!
    let date = Date()
    let formatter = DateFormatter()
    var diaryEntryObject: DiaryEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateFormat = "dd"
        day.text = formatter.string(from: date)
        formatter.dateFormat = "EEEE"
        dayName.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        let monthTxt = formatter.string(from: date)
        formatter.dateFormat = "YYYY"
        let yearTxt = formatter.string(from: date)
        
        month.text = "\(monthTxt) \(yearTxt)"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func saveEntryBtn(_ sender: Any) {
        diaryEntryObject = DiaryEntry()!
        diaryEntryObject.entryText = entryTextView.text
        
        PostService.shared.uploadDiaryEntry(entryObject: diaryEntryObject)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}