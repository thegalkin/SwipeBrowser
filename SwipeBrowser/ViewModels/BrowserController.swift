//
//  BrowserController.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import Combine
import SwiftUI

final class BrowserController: ObservableObject {
    @Published var newPageOrderPromised: Bool = false
    
    
    public func openEmptyPage() {
        self.newPageOrderPromised = true
    }
    
    public func openNewPage(with url: URL) {
        
    }
}
