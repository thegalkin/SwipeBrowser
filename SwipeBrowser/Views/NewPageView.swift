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
    
    private var favoriteLinksArray: Binding<Array<Int>> {
        return Binding.constant(self.browserController.favoriteLinks.keys.sorted(by: <))
    }
    
    var body: some View {
        ZStack {
            Color.primary
            
                VStack {
                    Spacer ()
                    ForEach(0..<3) { key in
                        HStack{
                            Spacer ()
                            generateLink(with: browserController.favoriteLinks[key])
                            Spacer ()
                            generateLink(with: browserController.favoriteLinks[key])
                            Spacer ()
                        }
                        Spacer ()
                    }
                    Spacer ()
                }
            
        }
        .ignoresSafeArea()
        .onAppear {
            self.browserController.newPageButtonIsOn = false
        }
        .onDisappear {
            self.browserController.newPageButtonIsOn = true
        }
        
        
        
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
        Button(action:{
            //TODO: add new link
        }){
        Rectangle ()
            .frame(width: self.cardWidth, height: self.cardWidth)
            .background(.ultraThickMaterial)
            .overlay {
                Image(systemName: "plus").foregroundColor(Color.green)
//                    .frame(width: self.cardWidth, height: self.cardWidth, alignment: .center)
                    .font(.system(size: 50))
            }
            .cornerRadius(self.cornerRadius)
            
        }.buttonStyle(.plain)
    }
    
    
    
    
    
}

//struct NewPageView_Previews: PreviewProvider {
//    @StateObject static var browserController: BrowserController = .init()
//    static var previews: some View {
//        NewPageView ()
//            .environmentObject(browserController)
//        //        ContentView ()
//    }
//}
