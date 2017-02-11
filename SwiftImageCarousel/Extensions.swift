import UIKit

//
//  Extensions.swift
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandov using Gavril Tonev's functions on 1/3/17.
//  Copyright © 2016 Gavril Tonev. All rights reserved.
//

// MARK: - UIImageView
extension UIImageView {
    /// A couple of UIImageView extension methods used for dowloading an image async and and saving it to an image cache.
    /// The cache is used whenever possible so that another download initiation is avoided.
    func downloadImageAsync(contentsOf url: String, withCompletion completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {

                    // Decompresses the image on this thread to increase performance on the main thread
                    UIGraphicsBeginImageContextWithOptions(image.size, true, 1)
                    image.draw(at: CGPoint.zero)

                    if let decImage = UIGraphicsGetImageFromCurrentImageContext() {
                        UIGraphicsEndImageContext()
                        DispatchQueue.main.async {
                            completion(decImage)
                        }
                    }
                    UIGraphicsEndImageContext()
                }
            }
            task.resume()
            return task
        } else { return nil }
    }

    func downloadImageAsync(contentsOf url: String?, saveToCache imageCache: NSCache<NSString, UIImage>) -> URLSessionDataTask? {
        if let url = url {
            let encodedUrl = url.urlEncode()
            if let cachedImage = imageCache.object(forKey: encodedUrl as NSString) {
                self.image = cachedImage
            } else {
                return downloadImageAsync(contentsOf: encodedUrl) { image in
                    self.image = image
                    imageCache.setObject(image, forKey: encodedUrl as NSString, cost: 1)
                }
            }
        }
        return nil
    }
}

extension UIImage {
    class func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: SwiftImageCarouselVC.classForCoder()), compatibleWith: nil)
        }
        return image
    }
}


// MARK: - String
extension String {
    func urlEncode() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }

}
