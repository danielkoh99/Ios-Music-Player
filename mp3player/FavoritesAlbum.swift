//
//  FavoritesAlbum.swift
//  mp3player
//
//  Created by Dani on 27/04/2022.
//

import Foundation


class FavoritesAlbum: ObservableObject {
    private var albums: Set<String>
    let defaults = UserDefaults.standard
    
    init() {
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey: "FavoritesAlbum") as? Data {
            let albumData = try? decoder.decode(Set<String>.self, from: data)
            self.albums = albumData ?? []
        } else {
            self.albums  = []
        }
    }
    
    func getSongIds() -> Set<String> {
        return albums
    }
    
    func isEmpty() -> Bool {
        return albums.count < 1
    }
    
    func contains(_ album: DirModel) -> Bool {
        albums.contains(album.id)
    }
    
    func add(_ album: DirModel) {
        objectWillChange.send()
        albums.insert(album.id)
        save()
    }
    
    func remove(_ album: DirModel) {
        objectWillChange.send()
        albums.remove(album.id)
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(albums) {
            defaults.set(encoded, forKey: "FavoritesAlbum")
        }
    }
}
