//
//  FavoriteSongs.swift
//  mp3player
//
//  Created by Dani on 13/04/2022.
//

import AVFoundation
import Foundation
import SwiftUI

struct FavoriteSongs: View {
    @ObservedObject var favorites = Favorites()
    @Binding var songs: [Song]
    @State private var isSettingsView = false
    @Binding var theme: Bool
    @State var name: String
    @State var songIds: Set<String> = Favorites().getSongIds()
    @State private var isVisible = false
    @State private var shuffled = false

    var reload: () -> Void

    var addObservers: () -> Void

    var removeItem: (URL) -> Void

//    @State private var currentSong: Song = .init(id: <#String#>, title: <#String#>, lengthInSeconds: <#Double#>, url: <#URL#>, artist: <#String?#>, albumname: <#String?#>)

    var body: some View {
        let songArray = Array(songIds)
        var filtered = songs.filter { songArray.contains($0.id) }
//        for id in taskArray {
//            for song in songs {
//                if song.id == id {
//                    filtered.append(song)
//                }
//            }
//        }
        List {
            Text("\(filtered.count) songs")
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(EmptyView())
                .listRowSeparator(Visibility.hidden)
            HStack {
                Button("Play") {
                    resetQueue()
                    setupPlayer(items: filtered)
                    queuePlayer.play()
                }.buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
                    .tint(.blue)

                Button("Shuffle") {
                    resetQueue()
                    setupPlayer(items: filtered.shuffled())
                    queuePlayer.play()
                }.buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
                    .tint(.blue)
                //                    .frame(height: isVisible ? nil : 0)

                //            label: {
                //                        Label("Shuffle", systemImage: "shuffle")
                //                    }.tint(Color.textColor)
                //                    .frame(height: isVisible ? nil : 0, alignment: Alignment.center)
                //                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(EmptyView())
            .listRowSeparator(Visibility.hidden)
//        SongsView(songs: $songs, theme: $theme, name: "Favorites", reload: reloadIds, removeItem: removeItem, addObserver: addObservers)

            ForEach(filtered, id: \.self) { song in
                CardView(song: song)

                    .onTapGesture {
//                                            addObserver()

                        queuePlayer.replaceCurrentItem(with: AVPlayerItem(url: song.url))
                        queuePlayer.play()
                    }

                    .contextMenu {
                        Button {
                            print("Get info")
                        } label: {
                            Label("Get info", systemImage: "info.circle")
                        }

                        Button(role: .destructive) {
                            let deleted = FileManager.default.deleteFileAt(url: song.url)
                            if deleted {
                                removeItem(song.url)

                                filtered = filtered.filter { $0.id != song.id }
                            } else { return }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }

                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            Favorites().remove(song)

                            songIds = Favorites().getSongIds()
                        } label: {
                            Image(systemName: "star.slash")
//                                    .accentColor(favorites.contains(song) ? Color.red : Color.white)
                        }.tint(.yellow)
                    }
            }

            .listRowBackground(Color.bgColor)
        }
        .refreshable {
            songIds = Favorites().getSongIds()
        }
        .onAppear {
            songIds = Favorites().getSongIds()
        }
        .animation(.default, value: songs)

        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.horizontal)
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text("Favorites")
                    .font(.title2).fontWeight(.bold)
            })
        }
    }

//    func removeItem(item: URL) {
//        let filteredData = data.filter { $0.url != item }
//        data = filtered
//    }
    func reloadIds() {
//        let songArray = Array(songIds)

        songIds = Favorites().getSongIds()
//        songs = data.filter { songArray.contains($0.id) }
//        data = FileManager.default.allRecordedData(url: directoryUrl()!)!
    }
}
