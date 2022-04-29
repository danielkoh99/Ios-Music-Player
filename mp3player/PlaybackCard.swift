//
//  PlaybackCard.swift
//  mp3player
//
//  Created by Dani on 24/03/2022.
//

import AVFoundation
import SwiftUI
// card hovering, able to set player status and queue
var currentPlaying: Song?

struct PlaybackCard: View {
//    let song: Song
    @State var status: String = "paused"
    @State var current: Song? = currentPlaying
//    var player: AVQueuePlayer = avPlayer()
//    let player = Player()

//    if let url = url { (queuePlayer.currentItem?.asset as? AVURLAsset)?.url } else { return }

    @Binding var songs: [Song]
//    let url: URL? = (player.queuePlayer.currentItem?.asset as? AVURLAsset)?.url
//    @State private var currentItem: Song? = Player().currentItem
//    @State private var current: URL? = metaData(url: currentUrl!)

//    let currentItem = metaData(url: currentUrl!)
    var showSheet: (Bool) -> Void
    @State var isAnimating = true
    @State var angle: Double = 0.0
//    @State var queuePlayerState: AVQueuePlayer.TimeControlStatus = avPlayer().timeControlStatus
//    @State var current: Song = metaData(url: (queuePlayer.currentItem?.asset as? AVURLAsset)!.url)
    var foreverAnimation: Animation {
        Animation.linear(duration: 5.0)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
//        let url: URL? = (queuePlayer.currentItem?.asset as? AVURLAsset)?.url
//        let current = metaData(url: url!)
        VStack(alignment: .center) {
            HStack(alignment: .center) {
//                Text("HI")
                VStack {
                    Text(currentPlaying?.title ?? "")
                        .accessibilityAddTraits(.isHeader)
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                    Text(currentPlaying?.artist ?? "")
                        .accessibilityAddTraits(.isHeader)
                        .font(.caption)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }

//                Spacer()
                Button {} label: {
                    Image(systemName: "backward.end.fill")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                }.frame(maxWidth: .infinity)
                Button {
                    status == "paused" ? queuePlayer.play() : queuePlayer.pause()
                } label: {
                    Image(systemName: status == "paused" ? "play.fill" : "pause.fill")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                }.frame(maxWidth: .infinity)
                Button {
                    queuePlayer.advanceToNextItem()
                } label: {
                    Image(systemName: "forward.end.fill")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                }.frame(maxWidth: .infinity)
//                Spacer()

                Image(data: currentPlaying?.artwork, placeholder: "record.circle")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(.black, lineWidth: 1))
                    .rotationEffect(Angle.degrees(isAnimating ? angle : 0))
                    .onAppear {
                        withAnimation(foreverAnimation) {
                            angle = 360
                        }
                    }
            }
//            .onTapGesture {
//                queuePlayer.replaceCurrentItem(with: AVPlayerItem(url: current!.url))
//            }
        }
        .frame(alignment: .bottom)
        .id(currentPlaying)
        .frame(maxWidth: .infinity, maxHeight: 20)
        .contentShape(Rectangle())
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { value in
                if value.translation.width < 0 {
                    print("left")
                }

                if value.translation.width > 0 {
                    print("right")
                }
                if value.translation.height < 0 {
//                    showSheet(true)
                }

                if value.translation.height > 0 {
                    print("down")
                }
            })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                setupPlayer(items: data)
                queuePlayer.play()
                queuePlayer.volume = 0.0
                currentPlaying = songs.first
                addObservers()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                queuePlayer.pause()
                queuePlayer.volume = 1.0
            }
//            currentPlaying.observe(\.title, changeHandler: { (label, change) in
//                // text has changed
//            })
//            DispatchQueue.main.async {
//            let result = await player.queuePlayer.items()! == []
//            if player.queuePlayer.items().count > 0 {
//            setupNowPlaying(current: queuePlayer.currentItem!)
//            print(queuePlayer.currentItem as Any)
//            }
//            print(player.queuePlayer.currentItem as Any)

//                player.setupPlayer(items: songs)
            //                currentUrl = (player.queuePlayer.currentItem?.asset as? AVURLAsset)?.url
//            }
//                        let url: URL? = (player.queuePlayer.currentItem?.asset as? AVURLAsset)?.url
//                        let meta = metaData(url: url!)
//                        currentItem = meta
        }

        .padding()
        .foregroundColor(Color.textColor)
//        .background(Color.bgColor)
        .opacity(0.8)
    }
}
