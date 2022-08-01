//
//  BrowserController.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import Combine
import SwiftUI
import WebKit

//@MainActor
final class BrowserController: ObservableObject {
    
//  MARK: - Orders
    @Published var newTabOrderPromised: Bool = false
    
//  MARK: - Params
    @Published var newPageButtonIsOn: Bool = true
    
    @Published var isShowingSettingsSheet: Bool = false
    
    @Published var isShowingTabsView: Bool = false
    
    var tabsList: Array<Tab> {
        get {
            if let data: Data = UserDefaults.standard.value(forKey: "currentTabURL") as? Data {
                if let decoded = try? PropertyListDecoder().decode(Array<Tab>.self, from: data) {
                    return decoded
                }
            }
            return Array<Tab>.init()
        }
        set(newVal) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newVal), forKey: "currentTabURL")
            self.objectWillChange.send()
            self.currentTabViewID = UUID ()
        }
    }
    
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
    
//  MARK: - Favorite Links
    //TODO: propper adding link as in Yandex Browser
    public func addSiteToFavorites(_ newFavoriteLink: FavoriteLink, at location: Int) {
        
        guard 0...5 ~= location else {return}
        
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

//Mark: - Navigation
extension BrowserController {
    //  MARK: - BottomBar commands
    public func openNewEmptyPage() {
        self.newTabOrderPromised = true
    }

    public func openNewPage(with url: URL) {
        self.currentTabURL = url
    }

    public func openNewPage(having str: String) {
        DispatchQueue.main.async {
            var components: URLComponents = .init()
            components.scheme = "https"
            components.host = str
            if let url: URL = components.url, url.isValid {
                self.currentTabURL = url
            } else {
                //link failed, initiating search query
                
                let searchQuery: SearchEngineBuilder = .init(searchEngine: SearchEngineBuilder.selectedSearchEngine, searchQuery: str)
                guard let url: URL = searchQuery.url else {return}
                self.currentTabURL = url
            }
        }
    }
}


struct FavoriteLink: Codable {
    var id: UUID
    var urlString: String
    var url: URL? {
        URL(string: urlString)
    }
    var isSpecial: Bool
    var name: String
    /**png*/
    var image: Data?
    init(id: UUID, urlString: String, isSpecial: Bool, name: String, image: Data? = nil) {
        self.id = id
        self.urlString = urlString
        self.isSpecial = isSpecial
        self.name = name
        self.image = image
    }
    var isURLValid: Bool {
        url?.isValid == true
    }
}

struct Tab: Identifiable, Codable {
    var id: UUID
    var url: URL
    var snapShot: Data?
    var webView: Data?
}
