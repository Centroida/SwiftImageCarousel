//
//  InitialPageItemController
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 12/30/16.
//

import UIKit

///  InitialPageItemController is instantiated by InitialPageViewController. It implements methods used for downloading downloading & displaying an image and a segue method to the ScrollablePageViewController.
public class InitialPageItemController: UIViewController {

    // MARK: -  Outlets
    @IBOutlet var contentImageView: UIImageView!

    // MARK: - Variables
    ///  Keeps track of the InitialPageItemController currently in view. Passed to ScrollablePageViewController so it knows what ScrollablePageItemController to display.
    var itemIndex: Int = 0
    
    /// Passing on the delegate, so that it will get notified when an image is tapped
    var pageVCDelegate: InitialPageViewControllerDelegate?
    
    /// Enables/disables the showing of the modal gallery
    var showModalGalleryOnTap = true

    /// The array with the image URLs, passed to the ScrollablePageViewController.
    var contentImageURLs: [String]!
    /// The precise image URL that needs to be displayed in the ScrollablePageItemController currently in view.

    // MARK: - Functions
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        pageVCDelegate?.didTapPageItemController?(pageItemController: self)
        if showModalGalleryOnTap {
            self.performSegue(withIdentifier: "showScrollable", sender: nil)
        }
    }

    fileprivate func setupUI(){
        /// The UIImageView extension function that is used to download an image and save it to cache if possible.
        _ = contentImageView.downloadImageAsync(contentsOf: contentImageURLs[itemIndex], saveToCache: imageCache)
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScrollable" {
            if let scrollablePageVC = segue.destination as? ScrollablePageViewController {
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
