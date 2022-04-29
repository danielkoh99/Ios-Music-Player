//
//  SingleSong.swift
//  mp3player
//
//  Created by Dani on 17/03/2022.
//

import Foundation
import SwiftUI
struct SingleSong: View {
    @State var song: Song
    @State private var progress: Double = 0.0

//    let player = Player()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack {
                    Image(data: song.artwork, placeholder: "record.circle")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1))
                }
                Text(song.title)
                    .accessibilityAddTraits(.isHeader)
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                Text(song.artist ?? "")
                    .accessibilityAddTraits(.isHeader)
                    .font(.caption)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                Slider(value: player.playerQue()?.currentItem?.currentTime(), in: player.playerQue()?.currentItem?.currentTime().seconds ... song.lengthInSeconds, step: 0.0001, label: "S", minimumValueLabel: "s", maximumValueLabel: "s")
                Slider(value: $progress, in: 1 ... 100, step: 0.0001)
//                Progress(value: player.player?.currentItem?.currentTime().seconds, total: song.lengthInSeconds)
            }
            .onAppear {
//                play(url: song.url)
//                setupProgressTimer()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

// set the timer, which will update your progress bar. You can use whatever time interval you want

//    private func setupProgressTimer() {
//        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { _ in
//
//            self.updateProgress()
//
//        })
//    }
//
//    // update progression of video, based on it's own data
//
//    private func updateProgress() {
//        let duration = Float((player.queuePlayer.currentItem?.duration.seconds)!)
//        let currentMoment = Float((player.queuePlayer.currentItem?.currentTime().seconds)!)
//
//        progress = Float(currentMoment / duration)
//    }
// }
