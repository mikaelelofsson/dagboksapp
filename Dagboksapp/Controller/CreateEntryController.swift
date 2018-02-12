//
//  CreateEntryController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-30.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit
import Firebase

class CreateEntryController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var recordingName: String!
    @IBOutlet weak var dayName: UILabel!

    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
        {
        didSet {
            entryTextView.layer.cornerRadius = 6
            entryTextView.clipsToBounds = true
            entryTextView.layer.borderWidth = 0.5
            entryTextView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    
    var imageData: Data!
    var imagePicker = UIImagePickerController()
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entryTextView.text = recordingName
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
    
    @IBAction func openAudioRecorder(_ sender: Any) {
        performSegue(withIdentifier: "audioRecordingSegue", sender: self)
    }
    @IBAction func chooseImage(_ sender: Any) {
        
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker = UIImagePickerController()
                imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            } else {
        
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated:true, completion:nil)
    }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "audioRecordingSegue" {
            let destination = segue.destination as! AudioRecordingController
           destination.recordingName = recordingName
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        imageData = UIImageJPEGRepresentation(selectedImage!, 0.8)!
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = selectedImage!
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
