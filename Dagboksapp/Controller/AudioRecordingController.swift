//
//  AudioRecordingController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-02-07.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecordingController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let alertMessage = UIAlertController(title:"Finished recording", message: "Successfully recorded the audio", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
            
            present(alertMessage, animated:true, completion:nil)
        }
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


