//
// Created by Никита Галкин on 30.03.2021.
//

import SwiftUI

extension EnvironmentObject {
    var hasValue: Bool {
        !String (describing: self).contains ("_store: nil")
    }
}

