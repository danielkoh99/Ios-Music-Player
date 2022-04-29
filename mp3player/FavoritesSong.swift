//
//  JsonStore.swift
//  mp3player
//
//  Created by Dani on 13/04/2022.
//

import Foundation


class Favorites: ObservableObject {
    private var songs: Set<String>
    let defaults = UserDefaults.standard
    
    init() {
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey: "Favorites") as? Data {
            let songData = try? decoder.decode(Set<String>.self, from: data)
            self.songs = songData ?? []
        } else {
            self.songs = []
        }
    }
    
    func getSongIds() -> Set<String> {
        return songs
    }
    
    func isEmpty() -> Bool {
        return songs.count < 1
    }
    
    func contains(_ song: Song) -> Bool {
        songs.contains(song.id)
    }
    
    func add(_ song: Song) {
        objectWillChange.send()
        songs.insert(song.id)
        save()
    }
    
    func remove(_ song: Song) {
        objectWillChange.send()
        songs.remove(song.id)
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(songs) {
            defaults.set(encoded, forKey: "Favorites")
        }
    }
}
