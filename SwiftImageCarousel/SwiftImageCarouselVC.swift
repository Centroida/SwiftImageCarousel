import UIKit

//
//  SwiftImageCarouselVC.swift
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 1/3/17.
//

/// The delegate of a SwiftImageCarouselVC object must adopt this protocol. Optional methods of the protocol allow  the delegate to configure the appearance of the view controllers, the timer and get notified when a new image is shown
@objc public protocol SwiftImageCarouselVCDelegate: class {

    /// Fires when the timer starts helps to track of all the properties the timer has when it was started.
    ///
    /// - Parameter timer: The timer that manages the automatic swiping of images
    @objc optional func didStartTimer(_ timer: Timer)

    ///  Fires when the timer is on and a new SwiftImageCarouselItemVC gets instantiated every few seconds.
    ///
    /// - Parameter SwiftImageCarouselItemController: The next pageItemController that has been initialized due to the timer ticking
    @objc optional func didGetNextITemController(next SwiftImageCarouselItemController: SwiftImageCarouselItemVC)

    /// Fires when an unwinding action coming from GalleryItemVC is performed and a new SwiftImageCarouselItemVC gets instantiated.
    ///
    /// - Parameter SwiftImageCarouselItemController: The page controller received when unwinding the GalleryVC
    @objc optional func didunwindToSwiftImageCarouselVC(unwindedTo SwiftImageCarouselItemController: SwiftImageCarouselItemVC)

    ///  Fires when SwiftImageCarouselVC is initialized. Use it to setup the appearance of the paging controls (dots) of both the SwiftImageCarouselVC and the GalleryVC.
    ///
    /// - Parameters:
    ///   - firstPageControl: The page control in SwiftImageCarouselVC
    ///   - secondPageControl: The page control in GalleryVC
    @objc optional func setupAppearance(forFirst firstPageControl: UIPageControl, forSecond secondPageControl: UIPageControl)

    /// Fires when a pageItemController is tapped.
    ///
    /// - Parameter SwiftImageCarouselItemController: The SwiftImageCarouselItemVC taht is tapped
    @objc optional func didTapSwiftImageCarouselItemVC(swiftImageCarouselItemController: SwiftImageCarouselItemVC)
}

///  SwiftImageCarouselVC is the controller base class and initilizes the first view the user sees when a developer implements this carousel. It implements methods used for instantiating the proper page view, setting up the page controller appearance and setting up the timer used for automatic swiping of the page views.
public class SwiftImageCarouselVC: UIPageViewController {
    
    /// The model array of image urls used in the carousel.
    public var contentImageURLs: [String] = [] {
        didSet {
            getNextItemController()
        }
    }

    // MARK: - Delegate
    weak public var swiftImageCarouselVCDelegate: SwiftImageCarouselVCDelegate?

    /// When set to TRUE, sets the image container frame to extend over the UIPageControl frame but not cover it (it goes underneath). To see it the proper effect of this variable in most cases, the contentMode should be .scaleToFill. Note also that background of the page control defaults to .clear when this variable is set to TRUE Default value is FALSE.
    public var escapeFirstPageControlDefaultFrame = false

    /// Keeps track of the page control frame height and provides it when needed
    var pageControlFrameHeight: CGFloat = 0

    /// Enables/disables the showing of the modal gallery.
    public var showModalGalleryOnTap = true

    /// The image shown when an image to be downloaded does not do that successfully
    public var noImage: UIImage? = nil

    /// Enables resetting the UIViewContentMode of SwiftImageCarouselItemVC UIViewContentMode. The default is .scaleAspectFit.
    public var contentMode: UIViewContentMode = .scaleAspectFit

    // MARK: - Timer properties
    /// The timer that is used to move the next page item.
    var timer = Timer()

    /// Enables/disables the automatic swiping of the timer. Default value is true.
    public var isTimerOn = true

    /// The interval on which the view changes when the timer is on. Default value is 3 seconds.
    public var swipeTimeIntervalSeconds = 3.0

    /// Shows/hides the close button in the modal gallery. Default value is false.
    public var showCloseButtonInModalGallery = false

    /// This variable keeps track of the index used in the page control in terms of the array of URLs.
    fileprivate var pageIndicatorIndex = 0

    /// This variable keeps track of the index of the SwiftImageCarouselVC in terms of the array of URLs.
    fileprivate var currentPageViewControllerItemIndex = 0

    // MARK: - Unwind segue
    /// In this unwind method, it is made sure that the view that will be instantiated has the proper image (meaning that same that we unwinded from).
    /// It is also made sure that that pageIndicatorIndex is setup to the proper dot shows up on the page control.
    @IBAction func unwindToSwiftImageCarouselVC(withSegue segue: UIStoryboardSegue) {
        // Making sure that the proper page control appearance comes on here when unwinding.
        setupPageControl()
        if let galleryItemVC = segue.source as? GalleryItemVC {
            loadPageViewControllerWhenUnwinding(atIndex: galleryItemVC.itemIndex)
        }
    }
    
    /// Loads a view controller with the index from the unwind segue.
    ///
    /// - Parameter itemIndex: The index for the VC from the model that will be loaded
    func loadPageViewControllerWhenUnwinding(atIndex itemIndex: Int) {
        if let currentController = getItemController(itemIndex) {
            swiftImageCarouselVCDelegate?.didunwindToSwiftImageCarouselVC?(unwindedTo: currentController)
            pageIndicatorIndex = currentController.itemIndex
            let startingViewControllers = [currentController]
            setViewControllers(startingViewControllers, direction: .forward, animated: false, completion: nil)
        }
    }

    // MARK: - Functions
    /// Loads a starting view controller from the model array with an index.
    ///
    /// - Parameter index: The index for the VC from the model that will be loaded
    func loadPageViewController(atIndex index: Int = 0) {
        if let firstController = getItemController(index) {
            let startingViewControllers = [firstController]
            setViewControllers(startingViewControllers, direction: .forward, animated: true, completion: nil)
        }
    }

    /// A method for getting the next SwiftImageCarouselItemVC. Called only by the timer selector.
    @objc func getNextItemController() {
        guard let currentViewController = viewControllers?.first else { return }

        // Use delegate method to retrieve the next view controller.
        guard let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) as? SwiftImageCarouselItemVC else { return }

        swiftImageCarouselVCDelegate?.didGetNextITemController?(next: nextViewController)

        // Need to keep track of page indicator index in order to update it properly.
        pageIndicatorIndex = nextViewController.itemIndex
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }

    /// A method for getting SwiftImageCarouselItemVC with a given index.
    func getItemController(_ itemIndex: Int) -> SwiftImageCarouselItemVC? {
        if !contentImageURLs.isEmpty && itemIndex <= contentImageURLs.count {
            let pageItemController = storyboard!.instantiateViewController(withIdentifier: "SwiftImageCarouselItemVC") as! SwiftImageCarouselItemVC
            pageItemController.itemIndex = itemIndex < contentImageURLs.count ? itemIndex : 0
            pageItemController.contentImageURLs = contentImageURLs
            pageItemController.swiftImageCarouselVCDelegate = swiftImageCarouselVCDelegate
            pageItemController.showModalGalleryOnTap = showModalGalleryOnTap
            pageItemController.contentMode = contentMode
            pageItemController.noImage = noImage
            pageItemController.showCloseButtonInModalGallery = showCloseButtonInModalGallery
            return pageItemController
        }
        return nil
    }

    // MARK: - Timer Function
    func startTimer() {
        if timer.isValid {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: swipeTimeIntervalSeconds, target: self, selector: #selector(getNextItemController), userInfo: nil, repeats: true)
        swiftImageCarouselVCDelegate?.didStartTimer?(timer)
    }

    // MARK: - Page Indicator
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImageURLs.count
    }

    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pageIndicatorIndex
    }

    // MARK: - Setup page control
    func setupPageControl() {
        view.backgroundColor = .white
        // Default appearance
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .orange
        appearance.currentPageIndicatorTintColor = .gray
        appearance.backgroundColor = .clear

        // Custom appearance setup with delegation from outside this framework.
        let firstAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [SwiftImageCarouselVC.self])
        let secondAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [GalleryVC.self])
        swiftImageCarouselVCDelegate?.setupAppearance?(forFirst: firstAppearance, forSecond: secondAppearance)
    }

    // MARK: - View Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        loadPageViewController()
        setupPageControl()
    }

    /// A method fixing the bounds of the image so that page control with the dots does not cover that particular image.
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if escapeFirstPageControlDefaultFrame {
            for view in self.view.subviews {
                if view is UIScrollView {
                    // Sets the image container frame to extend over the UIPageControl frame but not cover it (it goes underneath).
                    // To see it properly working contentMode should be .scaleToFill
                    // 37 is generally the default height of a UIPageControl
                    if pageControlFrameHeight != 0 {
                        view.frame = CGRect(x: view.frame.minX , y: view.frame.minY, width: view.frame.width, height: view.frame.height + pageControlFrameHeight)
                    }
                } else if view is UIPageControl {
                    pageControlFrameHeight = view.frame.height
                    view.backgroundColor = .clear
                }
            }
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isTimerOn {
            startTimer()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    override public var prefersStatusBarHidden : Bool { return true }
}

// MARK: - UIPageViewControllerDataSource
extension SwiftImageCarouselVC: UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard contentImageURLs.count > 1  else { return nil }

        let itemController = viewController as! SwiftImageCarouselItemVC

        let nextIndex = itemController.itemIndex > 0 ? (itemController.itemIndex - 1) : (contentImageURLs.count - 1)
        return getItemController(nextIndex)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard contentImageURLs.count > 1 else { return nil }

        let itemController = viewController as! SwiftImageCarouselItemVC

        let previousIndex = itemController.itemIndex + 1 < contentImageURLs.count ? (itemController.itemIndex + 1) : (0)
        return getItemController(previousIndex)
    }
}
