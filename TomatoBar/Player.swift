import AVFoundation
import SwiftUI

class TBPlayer: ObservableObject {
    private var windupSound: AVAudioPlayer
    private var dingSound: AVAudioPlayer
    private var tickingSound: AVAudioPlayer

    @AppStorage("windupVolume") var windupVolume: Double = 1.0 {
        didSet {
            setVolume(windupSound, windupVolume)
        }
    }
    @AppStorage("dingVolume") var dingVolume: Double = 1.0 {
        didSet {
            setVolume(dingSound, dingVolume)
        }
    }
    @AppStorage("tickingVolume") var tickingVolume: Double = 1.0 {
        didSet {
            setVolume(tickingSound, tickingVolume)
        }
    }
    
    @AppStorage("alarmURI") var alarmURI = "spotify:track:5Wjjn7sW1VT9enCdZLqBK2" {
        didSet {
            if alarmURI.hasPrefix("https://open.spotify.com/track/") {
                let id = alarmURI
                    .replacingOccurrences(of: "https://open.spotify.com/track/", with: "")
                    .components(separatedBy: "?")[0]
                alarmURI = "spotify:track:\(id)"
            }
        }
    }
    
    @AppStorage("resumeInsteadOfTrack") var resumeInsteadOfTrack = false

    private func setVolume(_ sound: AVAudioPlayer, _ volume: Double) {
        sound.setVolume(Float(volume), fadeDuration: 0)
    }

    init() {
        let windupSoundAsset = NSDataAsset(name: "windup")
        let dingSoundAsset = NSDataAsset(name: "ding")
        let tickingSoundAsset = NSDataAsset(name: "ticking")

        let wav = AVFileType.wav.rawValue
        do {
            windupSound = try AVAudioPlayer(data: windupSoundAsset!.data, fileTypeHint: wav)
            dingSound = try AVAudioPlayer(data: dingSoundAsset!.data, fileTypeHint: wav)
            tickingSound = try AVAudioPlayer(data: tickingSoundAsset!.data, fileTypeHint: wav)
        } catch {
            fatalError("Error initializing players: \(error)")
        }

        windupSound.prepareToPlay()
        dingSound.prepareToPlay()
        tickingSound.numberOfLoops = -1
        tickingSound.prepareToPlay()

        setVolume(windupSound, windupVolume)
        setVolume(dingSound, dingVolume)
        setVolume(tickingSound, tickingVolume)
    }

    func playWindup() {
        windupSound.play()
    }

    func playDing() {
        dingSound.play()
    }

    func startTicking() {
        tickingSound.play()
    }

    func stopTicking() {
        tickingSound.stop()
    }
    
    func pauseSpotify() {
        TBSpotify.pause()
    }
    
    func playAlarm() {
        if resumeInsteadOfTrack {
            TBSpotify.resume()
        } else {
            TBSpotify.playAlarm(spotifyURI: alarmURI)
        }
    }
}
