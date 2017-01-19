//
//  SwiftImageCarouselItemVC.swift
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 12/30/16.
//

import UIKit

///  SwiftImageCarouselItemVC is instantiated by SwiftImageCarouselVC. It implements methods used for downloading downloading & displaying an image and a segue method to the GalleryVC.
public class SwiftImageCarouselItemVC: UIViewController {

    // MARK: -  Outlets
    @IBOutlet var contentImageView: UIImageView!

    // MARK: - Variables
    ///  Keeps track of the SwiftImageCarouselItemVC currently in view. Passed to GalleryVC so it knows what GalleryItemVC to display.
    var itemIndex: Int = 0
    
    /// Passing on the delegate, so that it will get notified when an image is tapped
    var SwiftImageCarouselVCDelegate: SwiftImageCarouselVCDelegate?
    
    /// Enables/disables the showing of the modal gallery
    var showModalGalleryOnTap = true

    /// The array with the image URLs, passed to the GalleryVC.
    var contentImageURLs: [String]!
    /// The precise image URL that needs to be displayed in the GalleryItemVC currently in view.

    // MARK: - Functions
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        SwiftImageCarouselVCDelegate?.didTapSwiftImageCarouselItemVC?(SwiftImageCarouselItemController: self)
        if showModalGalleryOnTap {
            self.performSegue(withIdentifier: "showGalleryVC", sender: nil)
        }
    }

    fileprivate func setupUI(){
        /// The UIImageView extension function that is used to download an image and save it to cache if possible.
        contentImageView.image = UIImage.bundledImage(named: "no-image")
        _ = contentImageView.downloadImageAsync(contentsOf: contentImageURLs[itemIndex], saveToCache: imageCache)
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGalleryVC" {
            if let scrollablePageVC = segue.destination as? GalleryVC {
                scrollablePageVC.pageIndicatorIndex = itemIndex
                scrollablePageVC.contentImageURLs = contentImageURLs
            }
        }
    }

    // MARK: - View Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
