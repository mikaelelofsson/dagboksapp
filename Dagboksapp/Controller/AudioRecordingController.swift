//
//  AudioRecordingController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-02-07.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit
import AVFoundation


class AudioRecordingController: UIViewController, UINavigationControllerDelegate{
    
    var recordingName: String!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    private var timer: Timer?
    private var elapsedTimeInSecond: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingName = "hejhej"
        navigationController?.delegate = self
        configure()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configure(){
        //Make stop- and playbutton disabled when user starts application
        stopButton.isEnabled = false
        playButton.isEnabled = false
        
        guard let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            let alertMessage = UIAlertController(title: "Error", message: "Failed to get the document directory for recording the audio. Please try again later.", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
            
            present(alertMessage, animated:true, completion:nil)
            
            return
        }
        
        //set the audio file
        
        recordingName = "recordingname"
        
        let audioFileURL = directoryURL.appendingPathComponent("MyAudioMemo.m4a")
        
        //setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            
            //Define the recorder setting
            
            let recorderSetting: [String:Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            //Initate and prepare the recorder
            
            audioRecorder = try AVAudioRecorder(url:audioFileURL, settings: recorderSetting)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            
        }
        catch {
            print(error)
        }
        
    }
    
    @IBAction func record(_ sender: Any) {
        
        //Stop the player before starting a new recording
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            
            //start Recording
            audioRecorder.record()
            self.startTimer()
            
            //Swap to pausebutton Image on recorderButton
            recordButton.setImage(UIImage(named: "Pause"), for: UIControlState.normal)
            }
        catch {
            print (error)
            }
        }
            
            else {
            //Paus recording
            self.audioRecorder.pause()
            pauseTimer()
            
            //Change pausebutton to record image
            recordButton.setImage(UIImage(named: "Record"), for: UIControlState.normal)
        }
        
        stopButton.isEnabled = true
        playButton.isEnabled = false
        }
    
    
    @IBAction func stop(_ sender: Any) {
        
        recordButton.setImage(UIImage(named: "Record"),for: UIControlState.normal)
        
        recordButton.isEnabled = true
        playButton.isEnabled = true
        stopButton.isEnabled = false
        
        //Stop the recorder
        audioRecorder?.stop()
        resetTimer()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
    }
    
    //MARK: - Timer functions
    func startTimer() {
//    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer) in
//        self.elapsedTimeInSecond += 1
//        self.updateTimerLabel()
//    })
    }
    
    func pauseTimer(){
        timer?.invalidate()
    }
    
    func updateTimerLabel() {
        let second = elapsedTimeInSecond % 60
        let minutes = (elapsedTimeInSecond / 60) % 60
        
        timeLabel.text = String(format: "%02d:%02d", minutes, second)
    }
    
    func resetTimer(){
    timer?.invalidate()
        elapsedTimeInSecond = 0
        updateTimerLabel()
    }
    
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
extension AudioRecordingController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let alertMessage = UIAlertController(title:"Finished recording", message: "Successfully recorded the audio", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
            
            present(alertMessage, animated:true, completion:nil)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.isSelected = false
        resetTimer()
        
        let alertMessage = UIAlertController(title:"Finish Playing", message:"Finish playing the recording", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
        present(alertMessage, animated:true, completion:nil)
    }
    
    @IBAction func play(_ sender: Any) {
        
        if !self.audioRecorder.isRecording {
            guard let player = try? AVAudioPlayer(contentsOf:self.audioRecorder.url)
                else {
                    print("Failed to initialize AVAudioPlayer")
                    return
            }
            
            audioPlayer = player
            audioPlayer?.delegate = self
            audioPlayer?.play()
            startTimer()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? CreateEntryController)?.recordingName = self.recordingName
    }
    
}

