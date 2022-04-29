//
//  mp3playerApp.swift
//  mp3player
//
//  Created by Dani on 17/03/2022.
//

import AVFoundation
import MediaPlayer
import MusicKit
import SwiftUI

// var currentItemObserver: NSKeyValueObservation?
// var audioQueueStatusObserver: NSKeyValueObservation?

@main
struct mp3playerApp: App {
    @State var data: [Song] = .init()
    @State private var searchText = ""
    @State var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDark")
    @State var directoryData: [Song] = .init()
    @State var directories: [DirModel] = .init()
    @State private var isSettingsView = false
    @State private var shuffled = false
    @State private var isVisible = false
    @State var songIds: Set<String> = Favorites().getSongIds()

    @State private var bottomSheetShown = false

    @ObservedObject var favorites = Favorites()
    @State var mode: EditMode = .inactive

    @State var currentPlaying: Song?
//    let player = Player()

//    init() {
//        player.setupSession()
//    }

    var body: some Scene {
        WindowGroup {
            TabView {
                GeometryReader { geometry in
                    NavigationView {
                        if isVisible {
                            ZStack {
                                SongsView(songs: $data, theme: $isDarkMode, name: "Songs", reload: reloadData, removeItem: removeItem, addObserver: addObservers).padding(.bottom, 70)
//                        if isVisible {
//        //                    Spacer()
//                            PlaybackCard()
//                        }
                            }.overlay(
                                BottomSheetView(isOpen: $bottomSheetShown, maxHeight: geometry.size.height * 0.8) {
                                    //                            SingleSong(song: song)
                                    PlaybackCard(songs: $data, showSheet: showSheet)

                                }, alignment: .bottom)

                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())

                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search songs")
//                {
//                    Text(data.map { $0.title.lowercased() }).searchCompletion("SwiftUI")
//                }
                .onChange(of: searchText) { searchText in

                    if !searchText.isEmpty {
                        let filtered = data.filter { $0.title.lowercased().contains(searchText.lowercased()) }
                        data = filtered
                    } else {
                        data = FileManager.default.allRecordedData(url: directoryUrl()!)!
                    }
                }

                .tabItem {
                    Label("Songs", systemImage: "list.bullet.rectangle")
                }
                NavigationView {
                    if isVisible {
                        FavoriteSongs(songs: $data, theme: $isDarkMode, name: "Favorites", reload: reloadIds, addObservers: addObservers, removeItem: removeItem)

                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
//                    SongsView(songs: $data, reload: reloadData, removeItem: removeItem)
                }

                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }

                NavigationView {
                    if isVisible {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                FoldersListView(directories: $directories, songs: $data, theme: $isDarkMode, reload: reloadData, removeItem: removeItem, addObserver: addObservers)

//                                if isVisible {
                                //                    Spacer()
//                                    PlaybackCard()
//                                }
                            }
//                            Spacer()
//                            PlaybackCard(current: metaData(url: (queuePlayer.currentItem?.asset as? AVURLAsset)!.url)).frame(alignment: .bottom)
                        }
//                        .overlay(PlaybackCard(current: $currentPlaying), alignment: .bottom)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
//                .onAppear {
//                    DispatchQueue.main.async {
//                    }
//                }
                .tabItem {
                    Label("Albums", systemImage: "folder")
                }
            }

//            .overlay(BottomSheetView(isOpen: <#T##Binding<Bool>#>, maxHeight: <#T##CGFloat#>, content: <#T##() -> _#>))
            .onAppear {
                DispatchQueue.main.async {
                    data = FileManager.default.allRecordedData(url: directoryUrl()!)!
                    directories = FileManager.default.allDirectories()
                    UserDefaults.standard.set(true, forKey: "isDark")
                    currentPlaying = data.first
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isVisible = true
                }
            }
            .onChange(of: isDarkMode, perform: { _ in
                data = FileManager.default.allRecordedData(url: directoryUrl()!)!
            })
        }
    }

    func removeItem(item: URL) {
        let filtered = data.filter { $0.url != item }
        data = filtered
    }

    func reloadIds() {
        print("reloaded")
        songIds = Favorites().getSongIds()
//        data = FileManager.default.allRecordedData(url: directoryUrl()!)!
    }

    func showSheet(show: Bool) {
        bottomSheetShown = true
    }

    func reloadData() {
        data = FileManager.default.allRecordedData(url: directoryUrl()!)!
    }

    func searchData() {
        data = data.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }

    func addObservers() {}
//
}
