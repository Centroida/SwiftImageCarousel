import UIKit

//
//  InitialPageViewController.swift
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 1/3/17.
//

/// Protocol implementing a bunch of functions to be used outside of the framework.
@objc public protocol InitialPageViewControllerDelegate: class {
    // TODO: Work on more functions to add possibly as well as naming?

    /// Delegate method that fires when the timer starts.
    /// In this way, a developer can keep track of all the properties the timer has when it was started.
    ///
    /// - Parameter timer: The timer received from the delegating class.
    @objc optional func didStartTimer(_ timer: Timer)

    ///  Delegate method that fires when the timer is on and a new item controller gets instantiated every few seconds. In this way, a developer can keep track of the newly instantiated pageItemController with class InitialPageItemController.
    ///
    /// - Parameter pageItemController: The page controller (with class InitialPageItemController) received from the delegating class when instantiating next item controller.
    @objc optional func didGetNextITemController(next pageItemController: InitialPageItemController)

    /// Delegate method that fires when an unwinding action coming from ScrollablePageItemController is performed and a new item controller gets instantiated. In this way, a developer can keep track of the newly instantiated pageItemController with class InitialPageItemController.
    ///
    /// - Parameter pageItemController: The page controller (with class InitialPageItemController) received from the delegating class when unwinding.
    @objc optional func didUnwindToPageViewController(unwindedTo pageItemController: InitialPageItemController)

    ///  Delegate method that fires when InitialPageViewController gets into view in an application implementing this framework.
    ///  (Please note that by PAGE CONTROL, it is meant the dots that keep track of the current view when Page View Controller Transition Style is Scroll.)
    ///  Using this method, a developer can setup the appearance of both the first(the one in InitialPageViewController) and the second(the one in ScrollablePageViewController) page controls at once if they need to.
    ///  The page controls cannot be seen instantiated in any of the classes that belong to in this particular framework. The reason for that is they come by default when implementing    UIPageViewController class.
    ///
    /// - Parameters:
    ///   - firstPageControl: The page control in InitialPageViewController
    ///   - secondPageControl: The page control in ScrollablePageViewController
    @objc optional func setupAppearance(forFirst firstPageControl: UIPageControl, forSecond secondPageControl: UIPageControl)
}


///  InitialPageViewController is the controller base class and initilizes the first view the user sees when a developer implements this carousel. It implements methods used for instantiating the proper page view, setting up the page controller appearance and setting up the timer used for automatic swiping of the page views.
public class InitialPageViewController: UIPageViewController {

    /// Default URLs are not provided. They need to be set up when using framework.
    public var contentImageURLs: [String] = []

    // MARK: - Delegate
    /// InitialPageViewController delegate variable to be used to get access to functions in InitialPageViewControllerDelegate.
    weak public var pageVCDelegate: InitialPageViewControllerDelegate?

    // MARK: - Timer properties
    /// The timer variable.
    var timer = Timer()
    /// Timer ON/OFF boolean variable. Timer for automatic swiping is set true(or ON) by default. If a developer wants it off, they need to set it to false.
    public var isTimerOn = true
    /// The interval on which the view changes when timer is on. Default is 3 seconds.
    public var swipeTimeIntervalSeconds = 3.0

    // MARK: - Variables
    /// This variable keeps track of the index used in the page control in terms of the array of URLs.
    fileprivate var pageIndicatorIndex = 0
    /// This variable keeps track of the index of the InitialPageViewController in terms of the array of URLs.
    fileprivate var currentPageViewControllerItemIndex = 0

    // MARK: - Unwind segue
    /// In this unwind with segue method, it is made sure that the view that will be instantiated has the proper image (meaning that same that we unwinded from).
    /// It is also made sure that that pageIndicatorIndex is setup to the proper dot shows up on the page control.
    @IBAction func unwindToPageViewController(withSegue segue: UIStoryboardSegue) {

        // Making sure that the proper page control appearance comes on here when unwinding.
        setupPageControl()

        if let scrollablePageItemVC = segue.source as? ScrollablePageItemController {
            if let currentController = getItemController(scrollablePageItemVC.itemIndex) {
                pageVCDelegate?.didUnwindToPageViewController?(unwindedTo: currentController)
                pageIndicatorIndex = currentController.itemIndex
                let startingViewControllers = [currentController]
                setViewControllers(startingViewControllers, direction: .forward, animated: false, completion: nil)
            }
        }
    }

    // MARK: - Functions
    /// A method that gets called when InitialPageViewController gets called for the first time. It then gets called every time on viewDidLoad but it actully won't matter if the timer is on.
    ///
    /// - Parameter index: The index which a developer would want to have as a starting point for the image carousel. One would usually want to start with the first one which is why the default index is 0.
    func loadPageViewController(atIndex index: Int = 0) {

        dataSource = self

        if contentImageURLs.count > 0 {
            if let firstController = getItemController(index) {
                let startingViewControllers = [firstController]
                setViewControllers(startingViewControllers, direction: .forward, animated: true, completion: nil)
            }
        }
        self.view.backgroundColor = .white
    }


    /// A method for getting the next InitialPageItemController when the timer is on.
    @objc func getNextItemController() {
        guard let currentViewController = viewControllers?.first else { return }

        // Use delegate method to retrieve the next view controller.
        guard let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) as? InitialPageItemController else { return }

        pageVCDelegate?.didGetNextITemController?(next: nextViewController)

        // Need to keep track of page indicator index in order to update it properly.
        pageIndicatorIndex = nextViewController.itemIndex
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }

    /// A method for getting InitialPageItemController with a given index.
    func getItemController(_ itemIndex: Int) -> InitialPageItemController? {
        /// The same method but within func getItemController(_ itemIndex: Int) used to just avoid typing it twice in the if-else below.
        func innerGetPageItemController (_ itemIndex: Int) -> InitialPageItemController {
            let pageItemController = storyboard!.instantiateViewController(withIdentifier: "InitialPageItemController") as! InitialPageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageURL = contentImageURLs[itemIndex]
            pageItemController.contentImageURLs = contentImageURLs
            return pageItemController
        }

        if itemIndex < contentImageURLs.count {
            return innerGetPageItemController(itemIndex)
        } else if itemIndex == contentImageURLs.count {
            return innerGetPageItemController(0)
        }
        return nil
    }

    // MARK: - Timer Function
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: swipeTimeIntervalSeconds, target: self, selector: #selector(getNextItemController), userInfo: nil, repeats: true)
        pageVCDelegate?.didStartTimer?(timer)
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
        // Default appearance to be used if no one sets up page controls apperance from outside this framework.
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .orange
        appearance.currentPageIndicatorTintColor = .gray
        appearance.backgroundColor = .clear

        /// Custom appearance setup with delegation from outside this framework.
        let firstAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [InitialPageViewController.self])
        let secondAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [ScrollablePageViewController.self])
        pageVCDelegate?.setupAppearance?(forFirst: firstAppearance, forSecond: secondAppearance)
    }

    // MARK: - View Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadPageViewController()
        setupPageControl()
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

    // A method we use fixing the bounds of the image so that page control with the dots does not cover that particular image when a user zooms in.
    // We use it in ScrollablePageItemController but we also will need to implement it here in order to avoid image position shift when segueing back and forth between Scrollable Page View Controller and ScrollablePageItemController.
    // Works buggy with embedded UIImage. Works fine with newly instantiated storyboard.
    //    override public func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        for view in self.view.subviews {
    //            if view is UIScrollView {
    //                view.frame = UIScreen.main.bounds
    //            } else if view is UIPageControl {
    //                view.backgroundColor = UIColor.clear
    //            }
    //        }
    //    }
}

// MARK: - UIPageViewControllerDataSource
extension InitialPageViewController: UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard contentImageURLs.count > 0 else { return nil }

        let itemController = viewController as! InitialPageItemController

        let nextIndex = itemController.itemIndex > 0 ? (itemController.itemIndex - 1) : (contentImageURLs.count - 1)
        return getItemController(nextIndex)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard contentImageURLs.count > 0 else { return nil }

        let itemController = viewController as! InitialPageItemController
        
        let previousIndex = itemController.itemIndex + 1 < contentImageURLs.count ? (itemController.itemIndex + 1) : (0)
        return getItemController(previousIndex)
    }
}
