//
//  DetailViewController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-29.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MapKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,AVAudioPlayerDelegate{

    
    @IBOutlet weak var closeButton: UIButton!
  
    @IBOutlet weak var mapButton: UIButton! {
        didSet {
            mapButton.layer.shadowColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
            mapButton.layer.shadowOffset = CGSize(width: -1, height: 1.8)
            mapButton.layer.shadowOpacity = 0.8
            mapButton.layer.shadowRadius = 0
            mapButton.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DiaryDetailHeaderView!
    
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var playAudio: UIButton!{
        didSet {
            playAudio.layer.shadowColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
            playAudio.layer.shadowOffset = CGSize(width: -1, height: 1.8)
            playAudio.layer.shadowOpacity = 0.8
            playAudio.layer.shadowRadius = 0
            playAudio.layer.masksToBounds = false
        }
    }
    var diaryEntry: DiaryEntry!
    var audioFileURL:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.orientation.isLandscape {
            self.headerView.frame.size.height = 100
        } else {
            self.headerView.frame.size.height = 350
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        if(diaryEntry.recordingName == "saknas"){
        playAudio.isHidden = true
        }
        else{
            configureAudioPlayer()
        }
        
        headerView.titleLabel.text = diaryEntry.birdName
        if let image = CacheManager.shared.getFromCache(key: diaryEntry.imageURL) as? UIImage {
            headerView.headerImageView.image = image
        }
        
        
        // MARK: - Table Data Source
        

        // Do any additional setup after loading the view.
    }
    
    
    private func configureAudioPlayer(){
        //Make stop- and playbutton disabled when user starts application
        playAudio.isEnabled = true
        
        guard let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            let alertMessage = UIAlertController(title: "Error", message: "Failed to get the document directory for recording the audio. Please try again later.", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
            
            present(alertMessage, animated:true, completion:nil)
            
            return
        }
        
        //set the audio file
        
        
        
        audioFileURL = directoryURL.appendingPathComponent(diaryEntry.recordingName)
        
        //setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        }
        catch {
            print(error)
        }
        
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        closeMapPopUp()
    }
    @IBAction func openMapView(_ sender: Any) {
        showMapPopUp()
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(diaryEntry.locationLat, diaryEntry.locationLon)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated:true)
        
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(diaryEntry.locationLat, diaryEntry.locationLon);
        myAnnotation.title = diaryEntry.birdName
        mapView.addAnnotation(myAnnotation)
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playAudio.isEnabled = true
        playAudio.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
      
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:DiaryDetailSubheadCell.self), for: indexPath) as! DiaryDetailSubheadCell
            
            cell.subheadTextLabel.text = "Sparad \(diaryEntry.date)"
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DiaryDetailTextCell.self), for: indexPath) as! DiaryDetailTextCell
            
            if(diaryEntry.entryText == "saknas"){
                diaryEntry.entryText = ""
            }
            cell.entryText.text = diaryEntry.entryText
            
            return cell
            
        default:
            fatalError("Failed")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMapPopUp() {
        //This function is for making the pop up view visible
        
        self.view.addSubview(mapContainerView)
        
        mapContainerView.center = self.view.center
//        mapContainerView.setProperties()
        
        mapContainerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        mapContainerView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.mapContainerView.alpha = 1
            self.mapContainerView.transform = CGAffineTransform.identity
            //starting the animation and setting different ending-values for it
            
        
        }
        
    }
    
    
    func closeMapPopUp() {
        //making the pop up view invisible
        
        UIView.animate(withDuration: 0.4, animations: {
            self.mapContainerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mapContainerView.alpha = 0
            
        }) { (succes:Bool) in
            self.mapContainerView.removeFromSuperview()
            //finally removing the view from the superview
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        if UIDevice.current.orientation.isLandscape {
                self.headerView.frame.size.height = 100
            } else {
                self.headerView.frame.size.height = 350
            }
    }
    
   
    
    @IBAction func playAudio(_ sender: Any) {
        playAudio.isEnabled = false
        guard let player = try? AVAudioPlayer(contentsOf: audioFileURL)
            else {
                print("Failed to initialize AVAudioPlayer")
                return}
        
        
        audioPlayer = player
        audioPlayer?.delegate = self
        audioPlayer?.play()
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
