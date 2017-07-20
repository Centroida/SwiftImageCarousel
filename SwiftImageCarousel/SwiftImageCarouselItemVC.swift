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
    @IBOutlet weak var contentImageView: UIImageView!
    
    // MARK: - Variables
    /// The image shown when an image to be downloaded does not do that successfully
    var noImage: UIImage? = nil

    ///  Keeps track of the SwiftImageCarouselItemVC currently in view. Passed to GalleryVC so it knows what GalleryItemVC to display.
    public var itemIndex: Int = 0

    /// Passing on the delegate, so that it will get notified when an image is tapped
    var swiftImageCarouselVCDelegate: SwiftImageCarouselVCDelegate?

    /// Enables/disables the showing of the modal gallery
    var showModalGalleryOnTap = true

    /// Shows/hides the close button in the modal gallery. Default value is false.
    var showCloseButtonInModalGallery = false

    /// Enables resetting the UIViewContentMode of SwiftImageCarouselItemVC UIViewContentMode. The default is .scaleAspectFit
    var contentMode: UIViewContentMode = .scaleAspectFit

    /// The array with the image URLs, passed to the GalleryVC.
    public var contentImageURLs: [String]!

    // MARK: - Functions
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        swiftImageCarouselVCDelegate?.didTapSwiftImageCarouselItemVC?(swiftImageCarouselItemController: self)
        if showModalGalleryOnTap {
            self.performSegue(withIdentifier: "showGalleryVC", sender: nil)            
        }
    }

    fileprivate func setupUI(){
        /// The UIImageView extension function that is used to download an image and save it to cache if possible.
        contentImageView.image = noImage
        
        contentImageView.contentMode = contentMode
        _ = contentImageView.downloadImageAsync(contentsOf: contentImageURLs[itemIndex], saveToCache: imageCache)
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGalleryVC" {
            if let scrollableGalleryVC = segue.destination as? GalleryVC {
                scrollableGalleryVC.pageIndicatorIndex = itemIndex
                scrollableGalleryVC.contentImageURLs = contentImageURLs
                scrollableGalleryVC.noImage = noImage
                scrollableGalleryVC.showCloseButtonInModalGallery = showCloseButtonInModalGallery
            }
        }
    }

    // MARK: - View Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
