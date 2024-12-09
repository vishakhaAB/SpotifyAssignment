//
//  Untitled.swift
//  Spotify
//
//  Created by Admin on 09/12/24.
//
import UIKit

struct Playlist: Codable {
    var name: String = ""
    var resultArray: [Result] = []
}

class LibraryViewModel: NSObject {
    
    var playlistArray: [Playlist] = []
    var searchResultArray: [Result] = []

    override init() {
        var mostRecentArray = [Playlist]()
        playlistArray = AppHelper.sharedInstance.getPlaylistData()
       
        let totalIndices = playlistArray.count - 1

        for arrayIndex in 0...totalIndices {
            mostRecentArray.append(playlistArray[totalIndices - arrayIndex])
        }
        playlistArray = mostRecentArray
        
    }
    
    func callSearchAPI(searchKey: String, completion: @escaping ([Result]?, Error?) -> Void) {
        let url = URL(string: "https://itunes.apple.com/search?term=\(searchKey)&entity=song")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(SearchModel.self, from: data)
                print(decodedResponse)
                self.searchResultArray = decodedResponse.result ?? []
                completion(decodedResponse.result, nil)
            } catch let error {
                print("Failed to load: \(error.localizedDescription)")
                completion(nil, error)
            }
        }.resume()
    }
}
