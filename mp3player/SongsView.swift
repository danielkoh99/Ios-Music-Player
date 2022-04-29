//
//  ContentView.swift
//  mp3player
//
//  Created by Dani on 17/03/2022.
//

import AVFoundation
import SwiftUI
struct SongsView: View {
    @Binding var songs: [Song]
    @State private var isSettingsView = false
    @State var mode: EditMode = .inactive
    @Binding var theme: Bool
    @State var name: String
    @State var player = queuePlayer
    @State private var isVisible = false
    @State private var shuffled = false
    @State private var isOpen = false

//    @State private var currentSong: Song = .init(id: <#String#>, title: <#String#>, lengthInSeconds: <#Double#>, url: <#URL#>, artist: <#String?#>, albumname: <#String?#>)
    @ObservedObject var favorites = Favorites()

    @State private var selection = Set<Song>()

    var reload: () -> Void

    var removeItem: (URL) -> Void

    var addObserver: () -> Void

    var body: some View {
        ZStack {
            VStack {
                List(selection: $selection) {
                    Text("\(songs.count) songs").frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: isVisible ? nil : 0)
                        .listRowBackground(EmptyView())
                        .listRowSeparator(Visibility.hidden)
                    HStack {
                        Button("Play") {
                            resetQueue()
//                            currentItemObserver?.invalidate()

                            setupPlayer(items: songs)
                            queuePlayer.replaceCurrentItem(with: AVPlayerItem(url: songs.first!.url))

                            addObserver()
                            queuePlayer.play()

                        }.buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .controlSize(.large)
                            .tint(.blue)

                        Button("Shuffle") {
                            shuffled = true
                            resetQueue()
//                            currentItemObserver?.invalidate()

                            let shuffled = songs.shuffled()

                            setupPlayer(items: shuffled)
                            queuePlayer.replaceCurrentItem(with: AVPlayerItem(url: shuffled.first!.url))

                            addObserver()
                            queuePlayer.play()

                        }.buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .controlSize(.large)
                            .tint(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(EmptyView())
                    .listRowSeparator(Visibility.hidden)

                    ForEach(songs, id: \.self) { song in
                        CardView(song: song)
                            .onTapGesture {
//                            currentSong = song
//                                print(queuePlayer.items() as Any)
                                if mode == .inactive {
                                    addObserver()

                                    queuePlayer.replaceCurrentItem(with: AVPlayerItem(url: song.url))
                                    queuePlayer.play()
                                }
                            }
                            .foregroundColor(theme ? Color.textColor : Color.bgColor)

                            .contextMenu {
                                Button {
                                    print("Get info")
                                } label: {
                                    Label("Get info", systemImage: "info.circle")
                                }
                                Button {
                                    actionSheet(fileUrl: song.url)
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }

                                Button(role: .destructive) {
                                    let deleted = FileManager.default.deleteFileAt(url: song.url)
                                    if deleted {
                                        removeItem(song.url)

                                    } else { return }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }

                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    if self.favorites.contains(song) {
                                        self.favorites.remove(song)
                                    } else {
                                        self.favorites.add(song)
                                    }
//                                    removeItem(song.url)
                                    reload()

                                } label: {
                                    Image(systemName: favorites.contains(song) ? "star.slash" : "star")
//                                    .accentColor(favorites.contains(song) ? Color.red : Color.white)
                                }.tint(.yellow)
                            }
                    }
                    .environment(\.editMode, $mode)
                    .listRowBackground(theme ? Color.bgColor : Color.textColor)
//                    .id(songs)
                }

                .edgesIgnoringSafeArea(.horizontal)
                .listStyle(GroupedListStyle())

                .refreshable {
                    reload()
                }
//                .onAppear {
//                    reload()
//                }
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.principal, content: {
                        Text(name)
                            .font(.title2).fontWeight(.bold)
                    })
                    ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                        if mode == .active {
                            Text(mode == .active ? "Editing" : "Not Editing")
                        }
                    }

                    ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                        if mode == .active {
                            Button(role: .destructive) {
                                for selected in selection {
                                    let deleted = FileManager.default.deleteFileAt(url: selected.url)
                                    if deleted {
                                        removeItem(selected.url)

                                    } else { return }
                                }
                                //
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        //                Button("Select") {}.foregroundColor(Color.bgColor)

                        EditButton()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        Button {
                            isSettingsView = true
                        } label: {
                            Label("Settings", systemImage: "gearshape.fill")

                        }.tint(.bgColor)
                            .accessibilityLabel("Settings")
                    }
                }

//                if isVisible {
                ////                    Spacer()
//                    PlaybackCard()
//                }

//                    print(player.queuePlayer.currentItem as Any)
            }
        }
//        .overlay(
//            BottomSheetView(isOpen: $bottomSheetShown, maxHeight: geometry.size.height * 0.8) {
//                //                            SingleSong(song: song)
//                PlaybackCard(current: $currentPlaying, showSheet: showSheet)
//
//            }, alignment: .bottom)
        .onAppear {
//            if !songs.isEmpty && queuePlayer.currentItem != nil {
//                isVisible = true
//            }

//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            ////                print(queuePlayer.items() as Any)
//                setupPlayer(items: songs)
//                queuePlayer.play()
//            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                queuePlayer.pause()

                isVisible = true
            }
        }
        .sheet(isPresented: $isSettingsView) {
            NavigationView {
                Settings(isDarkMode: $theme)
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.cancellationAction) {
                            Button("Dismiss") {
                                isSettingsView = false
                            }
                        }
                        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
                            Button("Done") {
                                isSettingsView = false
                            }
                        }
                    }
            }
        }.environment(\.editMode, $mode)
    }

    func setup(items: [Song]) {
//        player.resetQueue()
        setupPlayer(items: items)
//        player.queuePlayer.play()
    }

    func actionSheet(fileUrl: URL) {
//        guard let data = fileUrl else { return }
        let av = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
//        DispatchQueue.main.async {
//            UIApplication.shared.keyWindow?.rootViewController?
//                .present(av, animated: true, completion: nil)
//        }
        DispatchQueue.main.async {
            UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }?.rootViewController?.present(av, animated: true, completion: nil)
//            UIApplication.shared..filter { $0.isKeyWindow }.first?.rootViewController?.present(av, animated: true, completion: nil)
        }
    }
}
