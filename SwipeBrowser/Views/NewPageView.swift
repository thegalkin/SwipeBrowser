//
//  NewPageView.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 03.01.2022.
//

import SwiftUI
/**Новая страница с видео вставкой**/
struct NewPageView: View {
    @EnvironmentObject var browserController: BrowserController
    let cardWidth: CGFloat = UIScreen.main.bounds.width / 3
    let cornerRadius: CGFloat = 10
    var body: some View {
        LazyVGrid(columns: coloumns, alignment: .center, spacing: self.cardWidth) {
            ForEach(browserController.favoriteLinks.keys.sorted(by: >), id: \.self) { key in
                generateLink(with: browserController.favoriteLinks[key])
            }
        }
    }
    
    private var coloumns: [GridItem] {
        Array<GridItem>.init(repeating:
                                GridItem(.fixed(cardWidth),
                                         spacing: cardWidth,
                                         alignment: Alignment.center),
                             count: 2
        )
    }
    
    private func linkCell(opens favoriteLink: FavoriteLink) -> some View {
        generateLink(with: favoriteLink)
            .onTapGesture {
                browserController.openNewPage(with: favoriteLink.url)
            }
    }
    
    //TODO: link generator with yandex api for differently styled links
    @ViewBuilder
    private func generateLink(with favoriteLink: FavoriteLink?) -> some View {
        
        if let favoriteLink = favoriteLink {
            if favoriteLink.isSpecial {
                //for special links
                EmptyView()
            } else {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .frame(width: self.cardWidth, height: self.cardWidth)
                    .overlay {
                        Text(favoriteLink.name.prefix(1))
                    }
            }
        } else {
            emptyCell
            
        }
    }
    
    private var emptyCell: some View {
        RoundedRectangle(cornerRadius: self.cornerRadius)
            .frame(width: self.cardWidth, height: self.cardWidth)
    }
    
    
    
    
}

struct NewPageView_Previews: PreviewProvider {
    static var previews: some View {
        NewPageView ()
        //        ContentView ()
    }
}
