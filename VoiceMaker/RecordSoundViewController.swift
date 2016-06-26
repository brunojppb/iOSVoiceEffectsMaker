//
//  ViewController.swift
//  VoiceMaker
//
//  Created by Bruno Paulino on 6/26/16.
//  Copyright © 2016 brunopaulino. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stopRecordingButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        self.recordLabel.text = "Recording in progress..."
        self.stopRecordingButton.enabled = true
        self.recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordFilename = "recordVoice.wav"
        let pathList = [dirPath, recordFilename]
        let filePath = NSURL.fileURLWithPathComponents(pathList)!
        print(filePath)
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        try! self.audioRecorder = AVAudioRecorder(URL: filePath, settings: [:])
        self.audioRecorder.delegate = self
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        self.recordLabel.text = "Tap to record"
        self.stopRecordingButton.enabled = false
        self.recordButton.enabled = true
        
        self.audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playAudioVC = segue.destinationViewController as! PlayAudioViewController
            let recordedAudioURL = sender as! NSURL
            playAudioVC.recordedAudioURL = recordedAudioURL
        }
    }
}

extension RecordSoundViewController : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording done!")
        if flag {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Record just failed")
        }
    }
}


















