//
//  DirModel.swift
//  mp3player
//
//  Created by Dani on 30/03/2022.
//

import Foundation
import UIKit

struct DirModel: Identifiable, Hashable, Codable {
    let id: String
    var name: String
    let url: URL
    let artwork: Data?
    init(id: String, name: String, url: URL, artwork: Data?) {
        self.id = id
        self.name = name
        self.url = url
        self.artwork = artwork
    }
}
