//
//  Files.swift
//  mp3player
//
//  Created by Dani on 19/03/2022.
//

import AVFoundation
import Foundation
import SwiftUI

var data = [Song]()

func directoryUrl() -> URL? {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths.first
}

extension FileManager {
    func allRecordedData(url: URL?) -> [Song]? {
        if let url = url {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
//                print(directoryContents)

                for url in directoryContents {
                    if !url.hasDirectoryPath {
                        let asset = AVURLAsset(url: url)
                        if asset.isPlayable {
                            let urlString = url
                            let newData = metaData(url: urlString)
                            let found = data.contains { $0.url == url }
                            //    print(found)
                            if !found {
                                data.append(newData)
                            }
                        }

                    } else {
                        _ = allRecordedData(url: url)
                    }
                }
//                print(data)
                return data

                //                return directoryContents.filter { $0.pathExtension == "m4a" }
            } catch {
                print(error)
            }
        }

        return nil
    }

    func deleteFileAt(url: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.removeItem(atPath: url.path)
                } catch {
                    print("Could not delete file")
                }
            }
            return true
        }
    }

    func allDirectories() -> [DirModel] {
        var dirs = [DirModel]()
        if let documentsUrl = directoryUrl() {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])

                let subDirs = directoryContents.filter { $0.hasDirectoryPath }

                for url in subDirs {
                    guard let firstItem = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil).first else { return dirs }
                    let asset = AVURLAsset(url: firstItem)
                    let metadata = asset.metadata(forFormat: AVMetadataFormat.id3Metadata)

                    let artwork = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtwork).first?.dataValue ?? Data()

                    dirs.append(DirModel(id: url.path, name: url.lastPathComponent, url: url, artwork: artwork))
                }
                return dirs
            } catch let error as NSError {
                print(error)
            }
        }
        return []
    }

    func getDataFromSpecifiedDirs(dir: URL) -> [String] {
        if let documentsUrl = directoryUrl() {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])

                let subDirs = directoryContents.filter { $0.hasDirectoryPath }
                let subDirsName = subDirs.map { $0.lastPathComponent }

//                print(subDirsName)
//                print(subDirs)
                return subDirsName
            } catch let error as NSError {
                print(error)
            }
        }
        return []
    }

    func getMetaForOne(url: URL) -> Data {
        let results = allRecordedData(url: url)
        return results![0].artwork!
    }
}

func returnData() -> [Song]? {
//    print(data)
    return data
}

func metaData(url: URL) -> Song {
    let asset = AVURLAsset(url: url)
//    let formatsKey = "availableMetadataFormats"

    let metadata = asset.metadata(forFormat: AVMetadataFormat.id3Metadata)

    let artwork = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtwork).first?.dataValue ?? Data()
    let artist = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtist).first?.stringValue ?? "Uknown"
    let title = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierTitle).first?.stringValue ?? String(url.lastPathComponent.dropLast(4))
    let albumName = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierAlbumName).first?.stringValue ?? String(url.lastPathComponent.dropLast(4))
    let duration = asset.duration.seconds.rounded()
    var uiArtwork = UIImage(systemName: "record.circle")
    if !artwork.isEmpty {
        uiArtwork = UIImage(data: artwork)
    }

    let newData = Song(id: url.lastPathComponent, title: title, lengthInSeconds: duration, url: url, artwork: artwork, artist: artist, albumname: albumName)
    return newData
    ////    print(data.contains(newData))
//    let found = data.contains { $0.url == url }
    ////    print(found)
//    if found {
//        return
//    } else {
//        data.append(newData)
//    }
}

public extension Image {
//    public func encode(to encoder: Encoder) throws {
//        <#code#>
//    }

    init(data: Data?, placeholder: String) {
        guard let data = data,
              let uiImage = UIImage(data: data)
        else {
            self = Image(systemName: placeholder)
            return
        }
        self = Image(uiImage: uiImage)
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap { $0 as? UIWindowScene }?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
}

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
