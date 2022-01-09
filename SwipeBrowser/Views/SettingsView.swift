//
//  SettingsView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
/**Настройки приложения*/
fileprivate class Settings: ObservableObject {
    
}
struct SettingsView: View {
    @State var selectedSearchEngine: SearchEngineBuilder.SupportedSeachEngines = SearchEngineBuilder.selectedSearchEngine
    var body: some View {
        List {
            searchEnginePicker
            
        }
    }
    
    private var searchEnginePicker: some View {
        HStack {
            Label("Search Engine", systemImage: "magnifyingglass.circle")
            Picker("", selection: self.$selectedSearchEngine) {
                ForEach(SearchEngineBuilder.SupportedSeachEngines.allCases, id:\.self) { (searchEngine: SearchEngineBuilder.SupportedSeachEngines) in
                    Text(searchEngine.humanReadable())
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView ()
    }
}
