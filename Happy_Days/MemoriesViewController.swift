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
    
    private var memories = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPermissions()
    }
    
    private func loadMemories() {
        memories.removeAll()
        
        // attempt to load all the memories in our documents directory
        guard let files = try? FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: []) else { return }
        
         // loop over every file found
        for file in files {
            let fileName = file.lastPathComponent
            
            // check it ends with ".thumb" so we don't count each memory more than once
            if fileName.hasSuffix(".thumb") {
                
                // get the root name of the memory (i.e., without its path extension)
                let noExtension = fileName.replacingOccurrences(of: ".thumb", with: "")
                
                // create a full path from the memory
                let memoryPath = getDocumentsDirectory().appendingPathComponent(noExtension)
                
                // add it to our array
                memories.append(memoryPath)
            }
        }
        // section 0 is the search bar
        collectionView?.reloadSections(IndexSet(integer: 1))
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
