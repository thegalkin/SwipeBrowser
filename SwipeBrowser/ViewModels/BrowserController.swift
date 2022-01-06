//
//  BrowserController.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import Combine
import SwiftUI

//@MainActor
final class BrowserController: ObservableObject {
    //orders
    @Published var newPageOrderPromised: Bool = false
    
    //params
    @Published var newPageButtonIsOn: Bool = true
    
    var favoriteLinks: [Int : FavoriteLink] {
        get {
            if let data: Data = UserDefaults.standard.value(forKey: "favoriteLinks") as? Data{
                if var decoded = try? PropertyListDecoder().decode(Dictionary<Int, FavoriteLink>.self, from: data) {
                    let numbers = 0...5
                    numbers
                        .filter { !(decoded.keys.contains($0)) }
                        .forEach { decoded[$0] = nil }
                    
                    return decoded
                }
            }
            return Dictionary<Int, FavoriteLink>()
        }
        set(newVal) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newVal), forKey: "favoriteLinks")
            self.objectWillChange.send()
        }
    }
    
    
    
    
    public func openNewEmptyPage() {
        self.newPageOrderPromised = true
    }
    
    public func openNewPage(with url: URL) {
        
    }
    
    //TODO: propper adding link as in Yandex Browser
    public func addSiteToFavorites(with url: URL, at location: Int) {
        
        guard 0...5 ~= location else {return}
        
        let id: UUID = .init()
        let isSpecial: Bool = false
        let name: String = ""
        let image: UIImage? = nil
        let encodedImage: Data? = image?.pngData()
        let newFavoriteLink: FavoriteLink = .init(id: id, url: url, isSpecial: isSpecial, name: name, image: encodedImage)
        
        self.favoriteLinks[location] = newFavoriteLink
    }
}


struct FavoriteLink: Codable {
    var id: UUID
    var url: URL
    var isSpecial: Bool
    var name: String
    /**png*/
    var image: Data?
}
