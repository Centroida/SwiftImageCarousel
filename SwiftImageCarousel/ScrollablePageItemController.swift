import UIKit

//
//  ScrollablePageItemController
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 1/3/17.
//

/// ScrollablePageItemController is the controller class that gets instantiated by ScrollablePageViewController class. Pretty much the same as the InitialPageViewController-InitialPageItemController pair. It implements methods used for the downloading the image that needs to be displayed, a segue that unwinds to the InitialPageViewController as well as delegate methods for zooming in on the image in view - that is what mainly makes this class different than InitialPageItemController.
class ScrollablePageItemController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = contentImageView.frame.size
            scrollView.delegate = self
        }
    }

    // MARK: - Variables
    var itemIndex = 0
    var productImageURL: String?

    @IBAction func tapBigImage(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindToPageViewController", sender: self)
    }

    // MARK: - setupUI Function
    fileprivate func setupUI(){
        _ = contentImageView.downloadImageAsync(contentsOf: productImageURL, saveToCache: imageCache)
        scrollView?.contentSize = contentImageView.frame.size
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UIScrollViewDelegate
extension ScrollablePageItemController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentImageView
    }
}

