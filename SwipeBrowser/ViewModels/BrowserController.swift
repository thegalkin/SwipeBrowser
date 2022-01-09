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
    
//  MARK: - Orders
    @Published var newTabOrderPromised: Bool = false
    
//  MARK: - Params
    @Published var newPageButtonIsOn: Bool = true
    
    @Published var isShowingSettingsSheet: Bool = false
    
    var currentTabURL: URL? {
        get {
            if let data: Data = UserDefaults.standard.value(forKey: "currentTabURL") as? Data {
                if let decoded = try? PropertyListDecoder().decode(URL.self, from: data) {
                    return decoded
                }
            }
            return nil
        }
        set(newVal) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newVal), forKey: "currentTabURL")
            self.objectWillChange.send()
            self.currentTabViewID = UUID ()
            
        }
    }
    
    @Published var currentTabViewID: UUID = .init()
    
//  MARK: - ButtomBar commands
    public func openNewEmptyPage() {
        self.newTabOrderPromised = true
    }
    
    public func openNewPage(with url: URL) {
        self.currentTabURL = url
    }
    
    public func openNewPage(having str: String) {
        var components: URLComponents = .init()
        components.scheme = "https"
        components.host = str
        if let url: URL = components.url {
            self.currentTabURL = url
        } else {
            //link failed, initiating search query
            
            let searchQuery: SearchEngineBuilder = .init(searchEngine: SearchEngineBuilder.selectedSearchEngine, searchQuery: str)
            guard let url: URL = searchQuery.url else {return}
            self.currentTabURL = url
        }
        
    }
    
    
//  MARK: - Favorite Links
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
}


struct FavoriteLink: Codable {
    var id: UUID
    var url: URL
    var isSpecial: Bool
    var name: String
    /**png*/
    var image: Data?
}
