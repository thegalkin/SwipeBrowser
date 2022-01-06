//
// Created by Никита Галкин on 21.02.2021.
//

//Необходимо, чтобы nav link  не подгружал данные пока на него не нажали. Иначе получаются тормоза на списках

import SwiftUI

struct NavLazyView<Content: View>: View {
    let build: () -> Content

    init (_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build ()
    }
}
