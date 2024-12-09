//
//  AppHelper.swift
//  Spotify
//
//  Created by Admin on 09/12/24.
//

import UIKit

class AppHelper {
    
    static let sharedInstance = AppHelper()
    let userDefaults = UserDefaults.standard

    private init() {
    }
    
    func showSimpleOKAlert(title: String, msg: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func addDataForPlaylist(result: [Result], name: String) {
        var existingData = getPlaylistData()
        for (i, val) in existingData.enumerated() where val.name == name {
            existingData[i].resultArray.append(contentsOf: result)
        }
        if let data = try? JSONEncoder().encode(existingData) {
            userDefaults.set(data, forKey: "playlist")
        }
    }

    func storePlaylistData(data: [Playlist]) {
        var existingData = getPlaylistData()
        existingData.append(contentsOf: data)
        if let data = try? JSONEncoder().encode(existingData) {
            userDefaults.set(data, forKey: "playlist")
        }
    }
    
    func getPlaylistData() -> [Playlist] {
        var data: [Playlist] = []
        if let contentData = userDefaults.object(forKey: "playlist") as? Data,
           let content = try? JSONDecoder().decode([Playlist].self, from: contentData) {
            print(content)
            data = content
            return data
        } else {
            return data
        }
    }
    
    func saveRecentSearchs() {
        
    }
}
