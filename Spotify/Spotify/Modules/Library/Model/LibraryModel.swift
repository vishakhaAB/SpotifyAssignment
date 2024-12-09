//
//  SearchModel.swift
//  Spotify
//
//  Created by Admin on 09/12/24.
//

struct SearchModel: Codable {
    let resultCount: Int?
    let result: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case result  = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        resultCount = try container.decode(Int.self, forKey: .resultCount)
        result = try container.decode([Result].self, forKey: .result)
    }

}
struct Result: Codable {
    let collectionName: String?
    let trackName: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let artistViewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case collectionName = "collectionName"
        case trackName = "trackName"
        case artworkUrl100 = "artworkUrl100"
        case previewUrl = "previewUrl"
        case artistViewUrl = "artistViewUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        collectionName = try container.decode(String.self, forKey: .collectionName)
        trackName = try container.decode(String.self, forKey: .trackName)
        artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        previewUrl = try container.decode(String.self, forKey: .previewUrl)
        artistViewUrl = try container.decode(String.self, forKey: .artistViewUrl)
    }
}
