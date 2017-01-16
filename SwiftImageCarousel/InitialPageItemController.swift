import UIKit

//
//  InitialPageItemController
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 12/30/16.
//

///  InitialPageItemController is the controller class that gets instantiated by InitialPageViewController class. It basically acts as the page and the views that this page contains. It implements methods used for the downloading the image that needs to be displayed as well as a segue method to the ScrollablePageViewController.
public class InitialPageItemController: UIViewController {

    // MARK: -  Outlets
    @IBOutlet var contentImageView: UIImageView!

    // MARK: - Variables
    ///  A variable that keeps track of the InitialPageItemController currently in view. It used to be passed to ScrollablePageViewController that needs to know what ScrollablePageItemController to display.
    var itemIndex: Int = 0

    /// The array with the image URLs that also needs to be passed to ScrollablePageViewController.
    var contentImageURLs: [String]!
    /// The precise image URL that needs to be displayed in the ScrollablePageItemController currently in view.
    var imageURL: String?

    // MARK: - Functions
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showScrollable", sender: nil)
    }

    fileprivate func setupUI(){
        /// The UIImageView extension function that is used to download an image and save it to cache if possible.
        _ = contentImageView.downloadImageAsync(contentsOf: imageURL, saveToCache: imageCache)
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScrollable" {
            if let scrollablePageVC = segue.destination as? ScrollablePageViewController {
                scrollablePageVC.initialItemIndex = itemIndex
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
