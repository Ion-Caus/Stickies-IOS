//
//  VoiceRecorderManager.swift
//  Stickies
//
//  Created by Ion Caus on 21.11.2022.
//

import Foundation
import AVFoundation
import SwiftUI

class VoiceRecorderManager : NSObject , ObservableObject , AVAudioPlayerDelegate {
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    
    @Published var isRecording : Bool = false
    
    @Published var recordingsList = [Recording]()
    
    override init() {
        super.init()
    }
    
    func requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if (granted) {
                print("Microphone permission granted.")
            }
            else {
                print("Microphone permission refused.")
            }
        }
    }
   
 
    func startRecording(id: String) -> URL{
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appendingPathComponent("Stickies.\(id).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            
        } catch {
            print("Failed to Setup the Recording")
        }
        
        return url
    }
    
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    func fetchAllRecording() {
            
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)

        for url in directoryContents {
            let ids = url.lastPathComponent.split(separator: ".")
            guard ids.count >= 3 else { continue }

            let recording = Recording(
                fileUrl : url,
                deckId: UUID(uuidString: String(ids[1])) ?? UUID(),
                cardId: UUID(uuidString: String(ids[2])) ?? UUID(),
                isPlaying: false)
            
            recordingsList.append(recording)
        }
            
    }

    func startPlaying(url : URL) {
      
        let playSession = AVAudioSession.sharedInstance()
            
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }
        catch {
            print("Playing failed in Device")
        }
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch {
            print("Playing Failed")
        }
                
    }

    func stopPlaying(url : URL) {
        audioPlayer?.stop()
    }
    
    func deleteRecording(url : URL) {
            
        do {
            try FileManager.default.removeItem(at : url)
        }
        catch {
            print("Can't delete")
        }
            
        for i in 0..<recordingsList.count {
            
            if recordingsList[i].fileUrl == url {
                if recordingsList[i].isPlaying == true {
                    stopPlaying(url: recordingsList[i].fileUrl)
                }
                
                recordingsList.remove(at : i)
                    
                break
            }
        }
    }
}
