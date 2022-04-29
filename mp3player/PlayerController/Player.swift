//
//  Player.swift
//  mp3player
//
//  Created by Dani on 17/03/2022.
//

import AVFoundation
import Foundation
import MediaPlayer
import MusicKit
import SwiftUI
class PlayerMusic {
    static let shared = PlayerMusic()
   

    private init() { }
}
var statusObserver: NSKeyValueObservation?
var currentItemObserver: NSKeyValueObservation?
var audioQueueStatusObserver: NSKeyValueObservation?

var session: AVAudioSession = .sharedInstance()
var queuePlayer: AVQueuePlayer = .init()
//var currentPlaying: Song? {
//    didSet { //called when item changes
//        print("changed")
//
//    }
//    willSet {
//        print("about to change")
//    }
//}

var status: String = "paused"
private var playerItemContext = 0

func setupPlayer(items: [Song]) {
    currentPlaying = items.first
//    resetQueue()
    var avMediaItems: [AVPlayerItem] = []
    let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    for song in items {
        let asset = AVAsset(url: song.url)
        let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: requiredAssetKeys)
        avMediaItems.append(item)
    }

    queuePlayer = AVQueuePlayer(items: avMediaItems)
    setupNowPlaying(current: queuePlayer.items().first!)

    setupSession()
    setupCommandCenter()
//        setupNotifications()
    toggleActiveSession(val: true)
    queuePlayer.allowsExternalPlayback = true
//    currentItemObserver = queuePlayer.observe(\.currentItem, options: [.new]) {
//        player, _ in
//
//
//        if player.currentItem !== nil {
//            //            print(player.currentItem as Any)
//            currentItem = metaData(url: (player.currentItem?.asset as? AVURLAsset)!.url)
    ////                updateNowPlaying()
//        }
//        audioQueueStatusObserver = player.currentItem?.observe(\.status, options: [.new, .old], changeHandler: {
//            playerItem, _ in
//
//            if playerItem.status == .readyToPlay {
//                print("current item status is ready")
//                playerStatus = "ready"
//                currentItem = metaData(url: (player.currentItem?.asset as? AVURLAsset)!.url)
//
//                //            setupNowPlaying(current: playerItem)
//
//                updateNowPlaying()
//            }
//        })
//        print(currentItem ?? "Item")
//        //            if songplayer.currentItem == nil {
//        //                setupNowPlaying(current: songplayer.currentItem!)
//        //            }
//        //            if
//        //            queuePlayer?.replaceCurrentItem(with: avMediaItems.first)
//
//        print("media item changed...")
//    }
//    audioQueueStatusObserver = queuePlayer.currentItem?.observe(\.status, options: [.new, .old], changeHandler: {
//        playerItem, _ in
//
//        if playerItem.status == .readyToPlay {
//            print("current item status is ready")
//            playerStatus = "ready"
//
    ////            setupNowPlaying(current: playerItem)
//
//            updateNowPlaying()
//        }
//    })
}

func setupSession() {
    do {
        try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)

    } catch {
        fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
    }
}

func addPlayerObserver() {
    currentItemObserver = queuePlayer.observe(\.currentItem, options: [.new]) {
        player, _ in

//            currentItem = metaData(url: (player.currentItem?.asset as? AVURLAsset)!.url)
//            print(currentItem!.title)
        //            queuePlayer?.play()
        //            queuePlayer?.volume = 0.0
        //            queuePlayer?.pause()
        //            print(queuePlayer?.currentItem as Any)

        if player.currentItem !== nil {
            //            print(player.currentItem as Any)
            currentPlaying = metaData(url: (player.currentItem?.asset as? AVURLAsset)!.url)
//                updateNowPlaying()
        }
        print(currentPlaying ?? "Item")
        //            if songplayer.currentItem == nil {
        //                setupNowPlaying(current: songplayer.currentItem!)
        //            }
        //            if
        //            queuePlayer?.replaceCurrentItem(with: avMediaItems.first)

        print("media item changed...")
    }
}

func setupCommandCenter() {
    let commandCenter = MPRemoteCommandCenter.shared()
    commandCenter.playCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
        queuePlayer.play()
        status = "playing"
        updateNowPlaying()
        return .success
    }
    commandCenter.pauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
        queuePlayer.pause()
        status = "paused"
        updateNowPlaying()
        return .success
    }
    commandCenter.changePlaybackPositionCommand.addTarget { event -> MPRemoteCommandHandlerStatus in
        if let event = event as? MPChangePlaybackPositionCommandEvent {
            let time = CMTime(seconds: event.positionTime, preferredTimescale: 1000000)
            queuePlayer.seek(to: time)
        }
        return .success
    }
    commandCenter.nextTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
//            if(queuePlayer?.currentItem)
        queuePlayer.advanceToNextItem()
        updateNowPlaying()
        return .success
    }
//        commandCenter.previousTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in queuePlayer?.()(); return .success }
}

func addObservers() {
//        currentItemObserver?.invalidate()
//        audioQueueStatusObserver?.invalidate()
//        currentItemObserver
    currentItemObserver = queuePlayer.observe(\.currentItem, options: [.new]) {
        player, _ in
//
        if player.currentItem !== nil {
            print(player.currentItem as Any)
            currentPlaying = metaData(url: (player.currentItem?.asset as? AVURLAsset)!.url)
            //                updateNowPlaying()

            addSingleObserver()
            updateNowPlaying()
            print("media item changed...")
        }
    }
    addStatusObserver()
}

func addStatusObserver() {
    statusObserver = queuePlayer.observe(\.timeControlStatus, options: [.new, .old], changeHandler: {
        playerItem, _ in
        if #available(iOS 10.0, *) {
            switch playerItem.timeControlStatus {
            case AVPlayer.TimeControlStatus.paused:
                print("Media Paused")
                status = "paused"
            case AVPlayer.TimeControlStatus.playing:
                print("Media Playing")
                status = "playing"
            case AVPlayer.TimeControlStatus.waitingToPlayAtSpecifiedRate:
                status = "waiting"
                print("Media Waiting to play at specific rate!")
            @unknown default:
                print("Media Paused")
                status = "paused"
            }
        } else {
            // Fallback on earlier versions
        }
    })
}

func addSingleObserver() {
//        let item =  currentItem as AVPlayerItem
    audioQueueStatusObserver = queuePlayer.currentItem?.observe(\.status, options: [.new, .old], changeHandler: {
        playerItem, _ in

        if playerItem.status == .readyToPlay {
            print("current item status is ready")
            currentPlaying = metaData(url: (playerItem.asset as? AVURLAsset)!.url)

            //            setupNowPlaying(current: playerItem)

            updateNowPlaying()
        }
    })
//        print(currentItem?.title)
}

func setupNowPlaying(current: AVPlayerItem) {
    // Define Now Playing Info
    var nowPlayingInfo = [String: Any]()
    let asset = (current.asset as? AVURLAsset)?.url
//        var asset = (queuePlayer?.currentItem?.asset as? AVURLAsset)?.url
//        if asset == nil {
//            asset = currentItem?.url
//        }
    let currentItem = metaData(url: asset!)
//    print(currentItem)
//        let url: URL? = asset
//        print(queuePlayer?.items())
//        let metadata = asset.metadata(forFormat: AVMetadataFormat.id3Metadata)
//
//        let artwork = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtwork).first?.dataValue ?? Data()
    ////        let songFileName: String? = String(url!.lastPathComponent.dropLast(4)) ?? String("Uknown")
//        let title = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierTitle).first?.stringValue ?? String(url!.lastPathComponent.dropLast(4))
//        let artist = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtist).first?.stringValue ?? "Uknown"

    if let image = UIImage(data: currentItem.artwork ?? Data()) {
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
            image
        }
    }
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = currentItem.lengthInSeconds

    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = queuePlayer.currentTime().seconds
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = queuePlayer.rate
    nowPlayingInfo[MPMediaItemPropertyTitle] = currentItem.title
    nowPlayingInfo[MPMediaItemPropertyArtist] = currentItem.artist

    // Set the metadata
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
}

func toggleActiveSession(val: Bool) {
    //    toggle session
    do {
        try session.setActive(val)
    } catch {
        print(error.localizedDescription)
    }
}

func play(url: URL) {
//        queuePlayer? = .init()
    let item = AVPlayerItem(url: url)
    queuePlayer.replaceCurrentItem(with: item)

    queuePlayer.play()
//        setupNowPlaying(current: item)
    updateNowPlaying()
}

func playNext(url: URL) {
    let item = AVPlayerItem(url: url)
    if queuePlayer.canInsert(item, after: queuePlayer.currentItem) {
        queuePlayer.insert(item, after: queuePlayer.currentItem)
    }
}

func loop(url: URL) {
    let item = AVPlayerItem(url: url)
    let looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
//    looper.loopingPlayerItems
    queuePlayer.play()
    if looper.loopCount == 2 {
        looper.disableLooping()
        queuePlayer.advanceToNextItem()
    }
}

func resetQueue() {
    queuePlayer = .init()
//    if queuePlayer.items().isEmpty { return } else {
//        queuePlayer.replaceCurrentItem(with: nil)
//        queuePlayer.removeAllItems()
//    }
}

func upcomingSongs() {
//    initQueue().items().
//    queuePlayer.items().filter
}

func updateNowPlaying() {
    // Define Now Playing Info
    let currentItem: Song
    if queuePlayer.status == .readyToPlay, queuePlayer.currentItem != nil {
        currentItem = metaData(url: (queuePlayer.currentItem?.asset as? AVURLAsset)!.url)
        currentPlaying = currentItem
//        print(currentItem.title)
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!

        if let image = UIImage(data: currentItem.artwork ?? Data()) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                image
            }
        }
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = currentItem.lengthInSeconds

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = queuePlayer.currentTime().seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = queuePlayer.rate
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentItem.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentItem.artist

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

//    func setupNotifications() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(notificationCenter,
//                                       selector: #selector(handleInterruption),
//                                       name: AVAudioSession.interruptionNotification,
//                                       object: nil)
////        notificationCenter.addObserver(self,
////                                       selector: #selector(handleRouteChange),
////                                       name: AVAudioSession.routeChangeNotification,
////                                       object: nil)
//    }

//    // MARK: Handle Notifications
func handleRouteChange(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
          let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
    else {
        return
    }
    switch reason {
    case .newDeviceAvailable:
        let session = AVAudioSession.sharedInstance()
        for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.headphones {
            print("headphones connected")
            DispatchQueue.main.sync {
                queuePlayer.play()
            }
            break
        }
    case .oldDeviceUnavailable:
        if let previousRoute =
            userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
        {
            for output in previousRoute.outputs where output.portType == AVAudioSession.Port.headphones {
                print("headphones disconnected")
                DispatchQueue.main.sync {
                    queuePlayer.pause()
                }
                break
            }
        }
    default: ()
    }
}

func handleInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: typeValue)
    else {
        return
    }

    if type == .began {
        print("Interruption began")
        // Interruption began, take appropriate actions
    } else if type == .ended {
        if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Interruption Ended - playback should resume
                print("Interruption Ended - playback should resume")
                //            play()
            } else {
                // Interruption Ended - playback should NOT resume
                print("Interruption Ended - playback should NOT resume")
            }
        }
    }
}

// }

// set up notification on change of input device
