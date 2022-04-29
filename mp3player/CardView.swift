//
//  CardView.swift
//  mp3player
//
//  Created by Dani on 17/03/2022.
//

import AVFoundation
import SwiftUI

struct CardView: View {
    @State var song: Song
//    var player: AVQueuePlayer = avPlayer()
    @State var isAnimating = true
    @State var angle: Double = 0.0
    @State private var fadeOut = false
    @State private var fadeIn = true
//    let player = Player()
    @ObservedObject var favorites = Favorites()

//    var uiArt = UIImage(data: song.artwork)

    var foreverAnimation: Animation {
        Animation.linear(duration: 5.0)
            .repeatForever(autoreverses: false)
    }

    var fadeOutAnim: Animation {
        Animation.easeOut(duration: 0.3)
    }

    var fadeInAnim: Animation {
        Animation.easeIn(duration: 0.3)
    }

    var body: some View {
        VStack(alignment: .leading) {
//            NavigationLink(destination:
//                SingleSong(song: song)) {
            HStack {
                VStack {
                    Text(song.title)
                        .animation(.easeInOut(duration: 1.0))
                        .accessibilityAddTraits(.isHeader)
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                    Text(song.artist ?? "")
                        .accessibilityAddTraits(.isHeader)
                        .font(.caption)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                    Text(song.lengthInSeconds.asString(style: .positional))
                        .accessibilityAddTraits(.isHeader)
                        .font(.caption)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }

                Image(data: song.artwork, placeholder: "record.circle")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                    .clipShape(Rectangle())
                    .shadow(radius: 10)
                    .overlay(Rectangle().stroke(.black, lineWidth: 1))
//                    .rotationEffect(Angle.degrees(isAnimating ? angle : 0))
//                    .onAppear {
//                        withAnimation(foreverAnimation) {
//                            angle = 360
//                        }
//                    }
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            withAnimation(fadeInAnim) {
                fadeIn = false
            }
        }.opacity(fadeIn ? 0.5 : 1)
        .padding(2)
    }
}
