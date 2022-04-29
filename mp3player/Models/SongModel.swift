//
//  SongModel.swift
//  mp3player
//
//  Created by Dani on 17/03/2022.
//

import Foundation
import UIKit

struct Song: Identifiable, Hashable, Codable {
    let id: String
    let url: URL
    let artist: String?
    var title: String
    var lengthInSeconds: Double
    let artwork: Data?
    let albumName: String?

    init(id: String, title: String, lengthInSeconds: Double, url: URL, artwork: Data? = nil, artist: String?, albumname: String?) {
        self.id = id
        self.title = title
        self.artwork = artwork
        self.artist = artist
        self.lengthInSeconds = lengthInSeconds
        self.url = url
        self.albumName = albumname
    }
}

// extension Song {
//    struct Data {
//        var title: String = ""
//        var lengthInSeconds: Double = 5
//        var url: URL = .init(fileURLWithPath: "")
//    }
//
//    var data: Data {
//        Data(title: title)
//    }
//
//    init(data: Data) {
//        id = UUID()
//        title = data.title
//        lengthInSeconds = Double(data.lengthInSeconds)
//        url = data.url
//    }
// }

// extension Song {
//    static let sampleData: [Song] =
//        [
//            Song(id: UUID(), title: "Someon i used toknow", lengthInSeconds: 10, url: ""),
//            Song(id: UUID(), title: "Metal song", lengthInSeconds: 5, url: ""),
//            Song(id: UUID(), title: "Pop song", lengthInSeconds: 5, url: "")
//        ]
// }
