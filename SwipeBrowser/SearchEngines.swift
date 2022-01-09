//
//  SearchEngines.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 09.01.2022.
//

import Foundation

struct SearchEngineBuilder {
    let searchEngine: SupportedSeachEngines
    let searchQuery: String
    
    var url: URL? {
        let urlString: String = Self.selectedSearchEngine.rawValue
        let urlStringWithSearchWord: String = urlString.appending(searchQuery)
        let url: URL? = .init(string: urlStringWithSearchWord)
        
        return url
    }
    
    static var selectedSearchEngine: SupportedSeachEngines {
        get {
            if let data: Data = UserDefaults.standard.value(forKey: "selectedSearchEngine") as? Data{
                if let decoded = try? PropertyListDecoder().decode(SupportedSeachEngines.self, from: data) {
                    return decoded
                }
            }
            return SupportedSeachEngines.duckduckgo
        }
        set(newVal) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newVal), forKey: "selectedSearchEngine")
        }
    }
    
    enum SupportedSeachEngines: String, Codable, CaseIterable {
        case google = "https://www.google.com/search?q="
        case yandex = "https://yandex.ru/search/?text="
        case bing = "https://www.bing.com/search?q="
        case duckduckgo = "https://duckduckgo.com/?q="
        case yahoo = "https://search.yahoo.com/search?p="
        case ask = "https://www.ask.com/web?q="
        case aol = "https://search.aol.com/aol/search?q="
        
        static var allCases: [SupportedSeachEngines] {
            return [.google, .yandex, .bing, .duckduckgo, .yahoo, .ask, .aol]
        }
        
        func humanReadable () -> String {
            switch self {
                case .google: return String("Google")
                case .yandex: return String("Yandex")
                case .bing: return String("Bing")
                case .duckduckgo: return String("DuckDuckGo")
                case .yahoo: return String("Yahoo")
                case .ask: return String("Ask")
                case .aol: return String("AOL")
            }
        }
    }
}


