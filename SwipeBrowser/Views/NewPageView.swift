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

    @State var newFavoriteLink: FavoriteLink = .init(id: UUID(), urlString: "shazoo.r", isSpecial: false, name: .empty)
    @State private var newFavoriteLinkLocation: Int = 0
    @State private var newFavoriteLinkPickerPresented: Bool = false
    @State private var newFavoriteLinkImageIsLoading: Bool = false
    @Namespace private var namespace
    @State var imageSize: CGFloat = 50

    private var favoriteLinksArray: Binding<Array<Int>> {
        return Binding.constant (self.browserController.favoriteLinks.keys.sorted (by: <))
    }

    var body: some View {
        ZStack {
            Color.primary
            VStack {
                Spacer ()
                ForEach (0 ..< 3) { row in
                    HStack {
                        Spacer ()
                        generateLink (with: row * 2 - 1)
//                            .matchedGeometryEffect(id: String("newLink"), in: self.namespace, isSource: true)
                        Spacer ()
                        generateLink (with: row * 2)
//                            .matchedGeometryEffect(id: String("newLink"), in: self.namespace, isSource: true)
                        Spacer ()
                    }
                    Spacer ()
                }
                Spacer ()
            }
            if newFavoriteLinkPickerPresented {
                favoriteLinkPickerLayout (with: newFavoriteLinkLocation)
//                    .matchedGeometryEffect(id: String("newLink"), in: self.namespace, isSource: false)
            }
        }
            .ignoresSafeArea ()
    }

//    private func linkCell (opens favoriteLink: FavoriteLink) -> some View {
//        generateLink (with: favoriteLink)
//            .onTapGesture {
//                browserController.openNewPage (with: favoriteLink.url)
//            }
//    }

    @ViewBuilder
    private func generateLink (with id: Int) -> some View {

        if let favoriteLink: FavoriteLink = browserController.favoriteLinks[id] {
            if favoriteLink.isSpecial {
                //for special links
                EmptyView ()
            } else {
                Button (action: {
                    browserController.openNewPage (with: favoriteLink.url!)
                }) {
                    VStack {
                        if let image: Data = favoriteLink.image, let uiImage: UIImage = UIImage (data: image) {
                            Image (uiImage: uiImage)
                                .resizable ()
                                .frame (width: cardWidth, height: cardWidth)
                                .cornerRadius (cornerRadius)
                        } else {
                            RoundedRectangle (cornerRadius: self.cornerRadius)
                                .frame (width: self.cardWidth, height: self.cardWidth)
                                .overlay {
                                    Text (favoriteLink.name.prefix (1))
                                }
                        }
                        if let name: String = favoriteLink.name {
                            Text (name)
                        } else {
                            if let url: URL = favoriteLink.url {
                                Text (url.host ?? String.empty)
                            } else {
                                Text (String.empty)
                            }
                            
                        }
                    }
                }
                    .onLongPressGesture {
                        self.newFavoriteLinkLocation = id
                        self.newFavoriteLinkPickerPresented = true
                    }
            }
        } else {
            emptyCell (with: id)
        }
    }

    private func emptyCell (with id: Int) -> some View {
        Button (action: {
            self.newFavoriteLinkLocation = id
            self.newFavoriteLinkPickerPresented = true
        }) {
            Rectangle ()
                .frame (width: self.cardWidth, height: self.cardWidth)
                .background (.ultraThickMaterial)
                .overlay {
                    Image (systemName: "plus").foregroundColor (Color.green)
                        .frame (width: self.cardWidth, height: self.cardWidth, alignment: .center)
                        .font (.system (size: 50))
                }
                .cornerRadius (self.cornerRadius)
        }
            .buttonStyle (.plain)
    }
}

//new link picker
extension NewPageView {
    func favoriteLinkPickerLayout (with id: Int) -> some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .background(.regularMaterial)
            VStack {
                Spacer ()
                favoriteLinkPickerMenuLayout (with: id)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(10)
                
                Spacer ()
            }
        }
        .animation (.easeIn(duration: 0.3), value: newFavoriteLinkPickerPresented)
    }

    private func favoriteLinkPickerMenuLayout (with id: Int) -> some View {
        HStack {
            favoriteLinkPickerImage (with: id)
            favoriteLinkPickerTextFields (with: id)
            favoriteLinkPickerApplyButton (with: id)
        }
    }

    @ViewBuilder
    private func favoriteLinkPickerImage (with id: Int) -> some View {
        Group {
            if let newFavoriteLinkImage: Data = self.newFavoriteLink.image {
                Image (uiImage: UIImage (data: newFavoriteLinkImage)!)
                    .resizable ()
                    .cornerRadius (self.cornerRadius)
                    .frame(width: imageSize, height: imageSize)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                    .zIndex(1)
//                    .animation(Animation.easeIn, value: self.newFavoriteLink.image != nil)
            } else {
                Rectangle ()
                    .background (.ultraThickMaterial)
                    .cornerRadius (self.cornerRadius)
                    .frame(width: imageSize, height: imageSize)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                    .zIndex(1)
                    .overlay {
                        if newFavoriteLinkImageIsLoading {
                            ProgressView ()
                                .progressViewStyle (.circular)
                                .frame(width: imageSize, height: imageSize)
                        } else {
                            Group{
                                if !self.newFavoriteLink.name.isEmpty {
                                    Text(self.newFavoriteLink.name.uppercased().prefix(1))
                                } else if !self.newFavoriteLink.urlString.isEmpty {
                                    Text(self.newFavoriteLink.urlString.uppercased().prefix(1))
                                }
                            }
                            .foregroundColor(Color.white)
                            .font(Font.system(size: imageSize))
                        }
                    }
                    
            }
        }
    }

    private func favoriteLinkPickerTextFields (with id: Int) -> some View {
        VStack {
            TextField (String ("✏️ Name"), text: self.$newFavoriteLink.name)
//                .textFieldStyle (RoundedBorderTextFieldStyle ())
                .padding(8)
                .background(.thickMaterial)
                .foregroundColor(Color.quaternaryLabel)
                .frame(width: 200)
                .border(width: 1, edges: [.bottom], color: .systemGray)
                .cornerRadius(10)
                .autocorrectionDisabled()
            Divider ()
                .frame(width: 200)
            TextField (String ("🔗 Enter link"), text: $newFavoriteLink.urlString)
                .padding(8)
                .background(.thickMaterial)
                .foregroundColor(Color.quaternaryLabel)
                .frame(width: 200)
                .border(width: 1, edges: [.bottom], color: .systemGray)
                .cornerRadius(10)
                .onChange(of: newFavoriteLink.urlString) { (newValue: String) in
                    DispatchQueue.main.async {
                        if let url: URL = URL (string: newValue) {
                            self.newFavoriteLink.image = getFaviconForUrl (url)
                        }
                    }
                }
                .onSubmit{self.applyFavoriteLink(with: id)}
                .autocorrectionDisabled()
        }
    }

    private func favoriteLinkPickerApplyButton (with id: Int) -> some View {
        Button (action: {self.applyFavoriteLink(with: id)}) {
            Image (systemName: "plus")
                .resizable ()
                .frame (width: 32, height: 32)
                .cornerRadius (self.cornerRadius)
                .foregroundColor(self.newFavoriteLink.isURLValid ? Color.green : Color.systemFill)
                .animation(.easeIn(duration: 0.2), value: self.newFavoriteLink.isURLValid)
        }
        .disabled (!self.newFavoriteLink.isURLValid)
    }
}

extension NewPageView {
    
    private func getFaviconForUrl(_ url: URL?) -> Data? {
        defer {
            self.newFavoriteLinkImageIsLoading = false
        }
        
        self.newFavoriteLinkImageIsLoading = true
        var result: Data?
        
        guard let url: URL = url,
              let imageURL: URL = URL(string: String("https://www.google.com/s2/favicons?sz=128&domain_url=\(url.absoluteString)")),
        url.isValid
        else { return nil }
           
        result = try? Data(contentsOf: imageURL)
        
        return result
    }

    private func applyFavoriteLink(with id: Int) {
        self.browserController.addSiteToFavorites(self.newFavoriteLink, at: id)
        eraseNewFavoriteLink()
        self.newFavoriteLinkPickerPresented = false
    }

    private func eraseNewFavoriteLink() {
        self.newFavoriteLink = .init(id: UUID(), urlString: .empty, isSpecial: false, name: .empty)
    }
    
    
}

struct FavoriteLinkPicker_Previews: PreviewProvider {
    @StateObject static var browserController: BrowserController = .init()
    static var previews: some View {
        NewPageView().favoriteLinkPickerLayout(with: 2)
            .environmentObject(browserController)
        //        ContentView ()
    }
}
