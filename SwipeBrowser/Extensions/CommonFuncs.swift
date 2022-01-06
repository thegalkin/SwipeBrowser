//
//  CommonFuncs.swift
//  MyPrepod13
//
//  Created by Никита Галкин on 27.09.2021.
//

import UIKit

func fail (desc: String) {
    #if DEBUG
        print ("assertFail:\(desc)")
        raise (SIGINT)
    #endif
}

func openSharedFilesApp (url: URL) {
    //    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let sharedurl = url.absoluteString.replacingOccurrences (of: "file://", with: "shareddocuments://")
    let furl: URL = URL (string: sharedurl)!
    DispatchQueue.main.async {
        UIApplication.shared.open (furl, options: [:], completionHandler: nil)
    }
}

/**
 Just breaks in debug right here without anything to say
 */
func assert () {
    assert (true == false, "")
}
