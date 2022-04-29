//
//  FolderListView.swift
//  mp3player
//
//  Created by Dani on 31/03/2022.
//

import Foundation
import SwiftUI

struct FoldersListView: View {
    @Binding var directories: [DirModel]
    @Binding var songs: [Song]
    @Binding var theme: Bool
    @State var filtered: [Song] = .init()

//    @State var name: URL
//    @State private var songs: [Song] = .init()
    var reload: () -> Void

    var removeItem: (URL) -> Void

    var addObserver: () -> Void

    @State private var bgImage: Data = .init()

    var body: some View {
        ForEach(directories, id: \.self) { folder in

            VStack {
                NavigationLink(destination:
                    SongsView(songs: $filtered, theme: $theme, name: folder.url.lastPathComponent, reload: reload, removeItem: removeItem, addObserver: addObserver)
//                    FoldersView(songs: $songs, name: folder.url, reload: reload, removeItem: removeItem)
                ) {
                    Text(folder.name)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }.simultaneousGesture(TapGesture().onEnded { filtered = songs.filter { $0.url.deletingLastPathComponent() == folder.url }})
            }
            .onAppear {
                DispatchQueue.main.async {
                    bgImage = FileManager.default.getMetaForOne(url: folder.url)
                }
            }
            .frame(width: 150, height: 150)
            .padding()
            .background(
                Image(data: folder.artwork, placeholder: "record.circle")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 10)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
                    .opacity(0.5)
            )
            .foregroundColor(Color.white)
//            .border(Color.textColor, width: 3)
//            .cornerRadius(10)
        }
        .padding(4)
    }
}
