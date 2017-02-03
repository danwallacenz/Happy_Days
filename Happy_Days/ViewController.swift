//
//  ViewController.swift
//  Happy_Days
//
//  Created by Daniel Wallace on 1/02/17.
//  Copyright © 2017 Daniel Wallace. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech

/*
 see info.plist
 
 NSPhotoLibraryUsageDescription = “We use this to let you import photos”
 NSMicrophoneUsageDescription = “We use this to record your narration”
 NSSpeechRecognitionUsageDescription = “We use this to transcribe your narration”
*/

class ViewController: UIViewController {

    @IBOutlet weak var helpLabel: UILabel!
 
    @IBAction func requestPermissions(_ sender: Any) {
        requestPhotosPermissions()
    }

    private func requestPhotosPermissions() {
        PHPhotoLibrary.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.requestRecordPermissions()
                } else {
                    self.helpLabel.text = "Photos permission was declined; please enable it in settings then tap Continue again."
                }
            }
        }
    }
    
    private func requestRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.requestTranscribePermissions()
                } else {
                    self.helpLabel.text = "Recording permission was declined; please enable it in settings then tap Continue again."
                }
            }
        }
    }

    private func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.authorizationComplete()
                } else {
                    self.helpLabel.text = "Transcription permission was declined; please enable it in settings then tap Continue again."
                }
            }
        }
    }
    
    private func authorizationComplete() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

