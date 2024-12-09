//
//  String.swift
//  Spotify
//
//  Created by Admin on 09/12/24.
//

import UIKit

extension URL {
    func getData(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: self, completionHandler: completion).resume()
    }
}
