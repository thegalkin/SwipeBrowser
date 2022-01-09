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
    @AppStorage("didLaunchBefore") var didLaunchBefore: Bool = false
    @AppStorage("isDarkModeOn") var isDarkModeOn: Bool = true
    var body: some View {
        List {
            searchEnginePicker
            darkModeSwitcher
        }
        .listStyle(.grouped)
        .onAppear {
            if !self.didLaunchBefore {
                UserDefaults.standard.set(try? PropertyListEncoder().encode(true), forKey: "isDarkModeOn")
            }
        }
    }
    
    private var searchEnginePicker: some View {
        HStack {
            Label("Search Engine", systemImage: "magnifyingglass.circle")
                .foregroundStyle(.green, .blue)
            Picker("", selection: self.$selectedSearchEngine) {
                ForEach(SearchEngineBuilder.SupportedSeachEngines.allCases, id:\.self) { (searchEngine: SearchEngineBuilder.SupportedSeachEngines) in
                    Text(searchEngine.humanReadable())
                }
            }
        }
    }
    
    private var darkModeSwitcher: some View {
        HStack {
            Label("Dark mode on?", systemImage: self.isDarkModeOn ? String("moon.circle.fill") :  String("sun.max.circle"))
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(
                                 self.isDarkModeOn ? .indigo : .yellow,
                                 self.isDarkModeOn ? .black : .black
                )
            Toggle("", isOn: self.$isDarkModeOn)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView ()
    }
}
