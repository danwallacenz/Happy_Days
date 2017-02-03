//
//  MemoriesViewController.swift
//  Happy_Days
//
//  Created by Daniel Wallace on 3/02/17.
//  Copyright © 2017 Daniel Wallace. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech

class MemoriesViewController: UICollectionViewController {    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        checkPermissions()
    }
    
    private func checkPermissions() {
        // check status for all three permissions
        let photosAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized
        let recordingAuthorized = AVAudioSession.sharedInstance().recordPermission() == .granted
        let transcribeAuthorized = SFSpeechRecognizer.authorizationStatus() == .authorized
        
        // make a single boolean out of all three
        let authorized = photosAuthorized && recordingAuthorized && transcribeAuthorized
        
        // if we're missing one, show the first run screen
        if authorized == false {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FirstRun") {
                    navigationController?.present(vc, animated: true)
            }
        }
    }
}
