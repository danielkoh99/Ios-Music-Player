//
//  FoldersList.swift
//  mp3player
//
//  Created by Dani on 30/03/2022.
//

import SwiftUI
struct FoldersView: View {
    @Binding var songs: [Song]
    @State var name: URL
//    let player = Player()
    var reload: () -> Void

    var removeItem: (URL) -> Void

    var body: some View {
        let filtered = songs.filter { $0.url.deletingLastPathComponent() == name }
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

            ForEach(filtered, id: \.self) { song in
                CardView(song: song)

//                    .onTapGesture {
//                        player.play(url: song.url)
//                    }

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

                            } else { return }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }

                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {} label: {
                            Label("Flag", systemImage: "star")

                        }.tint(.yellow)
                    }
            }

            .listRowBackground(Color.bgColor)
        }
//        .animation(.default, value: songs)
//        .id(UUID())
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.horizontal)
        .listStyle(GroupedListStyle())

        .refreshable {
            reload()
        }
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text(name.lastPathComponent)
                    .font(.title2).fontWeight(.bold)
            })
//            ToolbarItem(placement: .navigationBarTrailing, content: {
//                Button {} label: {
//                    Label("Settings", systemImage: "gearshape.fill")
//
//                }.tint(.bgColor)
//                    .accessibilityLabel("Settings")
//            })
        }
    }
}
