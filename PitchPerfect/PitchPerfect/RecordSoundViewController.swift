//
//  RecordSoundViewController.swift.swift
//  PitchPerfect
//
//  Created by Reem Aldughaither on 3/11/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recodButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false

    }


    @IBAction func recordAudio(_ sender: Any) {
        setEnabled(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setEnabled(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            let alert = UIAlertController(title: "Recording Error", message: "Record was not successful", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func setEnabled(recording: Bool){
        recordingLabel.text = recording ? "Recording in Progress" : "Tap to Record"
        if recording{
            stopRecordingButton.isEnabled = recording
            recodButton.isEnabled = !recording
        }
        else{
            recodButton.isEnabled = recording
            stopRecordingButton.isEnabled = !recording
        }
    }
    
}

