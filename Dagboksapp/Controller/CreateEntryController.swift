//
//  CreateEntryController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-30.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class CreateEntryController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var saveEntryButton: UIBarButtonItem!{
        didSet {
            navigationItem.title = NSLocalizedString("Spara", comment: "saveButton")
            
        }
    }
    @IBOutlet weak var addedNavigationItem: UINavigationItem! {
        didSet {
            navigationItem.title = NSLocalizedString("Lägg till fågel", comment: "createEntryTitle")
            
        }
    }
    @IBOutlet weak var audioButton: UIButton! {
        didSet {
            audioButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
            audioButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            audioButton.layer.shadowOpacity = 0.5
            audioButton.layer.shadowRadius = 4
            audioButton.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var cameraButton: UIButton! {
        didSet {
            cameraButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
            cameraButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            cameraButton.layer.shadowOpacity = 0.5
            cameraButton.layer.shadowRadius = 4
            cameraButton.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var birdNameView: UITextField!
    var recordingName: String = "saknas"
    @IBOutlet weak var dayName: UILabel!
    var imageURL: String = "saknas"
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
    var dateText:String?
     let manager = CLLocationManager()
    
    var imageData: Data! = nil
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var year: UILabel!
    var databaseRef: DatabaseReference!
    let date = Date()
    let formatter = DateFormatter()
    var diaryEntryObject: DiaryEntry!
    
    var locationLat: Double = 0.0
    var locationLon: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        imagePicker.delegate = self
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        locationLat = Double(location.coordinate.latitude)
        locationLon = Double(location.coordinate.longitude)
    }
    
    @IBAction func saveEntryBtn(_ sender: Any) {
        
        if !birdNameView.hasText {
            let uploadingMessage = UIAlertController(title: NSLocalizedString("Fel", comment: "error"),
                                                     message: NSLocalizedString("Du måste ange ett namn på fågeln", comment: "birdNeedsName"),
                                                     preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            uploadingMessage.addAction(action)
            present(uploadingMessage, animated:true)
            
        } else {
        
        let uploadingMessage = UIAlertController(title: NSLocalizedString("Ett ögonblick", comment: "justamoment"),
                                                 message: NSLocalizedString("Sparar inlägget...", comment: "saving"), preferredStyle: .alert)
        present(uploadingMessage, animated:true)
        
        diaryEntryObject = DiaryEntry()!
        diaryEntryObject.entryText = entryTextView.text
        diaryEntryObject.recordingName = recordingName
        diaryEntryObject.birdName = birdNameView.text!
        formatter.dateFormat = "dd-MMMM-YYYY"
        diaryEntryObject.date = formatter.string(from: date)
        diaryEntryObject.locationLon = locationLon
        diaryEntryObject.locationLat = locationLat
        
        
        
        PostService.shared.uploadDiaryEntry(entryObject: diaryEntryObject, imageData: imageData) {(doneUploading) in
            if doneUploading {
                self.dismiss(animated: true) {
                   
                    self.performSegue(withIdentifier: "goBackToTableView", sender: self)
                }
                
            }
            
        }
        }
        
        
    }
    
    

    
    
    @IBAction func openAudioRecorder(_ sender: Any) {
        performSegue(withIdentifier: "audioRecordingSegue", sender: self)
    }
    @IBAction func chooseImage(_ sender: Any) {
        
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera;
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            } else {
        
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated:true, completion:nil)
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
