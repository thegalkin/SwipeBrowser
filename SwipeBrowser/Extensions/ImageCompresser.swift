//
// Created by Никита Галкин on 25.01.2021.
//

import SwiftUI

extension UIImage {
    func resizeWithPercent (_ percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView (frame: CGRect (origin: .zero, size: CGSize (width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions (imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext () else {
            return nil
        }
        imageView.layer.render (in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext () else {
            return nil
        }
        UIGraphicsEndImageContext ()
        return result
    }

    func resizeWithWidth (_ width: CGFloat) -> UIImage? {
        let imageView = UIImageView (frame: CGRect (origin: .zero, size: CGSize (width: width, height: CGFloat (ceil (width / size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions (imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext () else {
            return nil
        }
        imageView.layer.render (in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext () else {
            return nil
        }
        UIGraphicsEndImageContext ()
        return result
    }
}