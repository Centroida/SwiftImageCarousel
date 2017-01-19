//
//  ScrollablePageViewController.swift
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 1/3/17.
//

import UIKit

/// ScrollablePageViewController is pretty much the same class as InitialOageViewController both in the storyboard which the reason that most variables and functions are not described into detail below. Unlike its cousin though, it instantiates a class - ScrollablePageItemController - that adds on the abilities to scroll and zoom on the image in view.
class ScrollablePageViewController: UIPageViewController {

    // MARK: - Variables
    var pageIndicatorIndex = 0
    var contentImageURLs = [String]()

    // MARK: - Functions
    /// A method that helps to instantiate the correct ScrollablePageItemController. It gets called rightaway when segue with identifier showScrollable finishes.
    fileprivate func loadPageViewController(atIndex startingViewControllerIndex: Int) {
        dataSource = self

        if !contentImageURLs.isEmpty {
            let firstController = getItemController(startingViewControllerIndex)!
            let startingViewControllers = [firstController]
            setViewControllers(startingViewControllers, direction: .forward, animated: true, completion: nil)
        }
    }
    
    /// A method that gets ScrollablePageItemController with a given index.
    ///
    /// - Parameter itemIndex: The index for the particular ScrollablePageItemController needed based on contentImageURLs array.
    /// - Returns: ScrollablePageItemController
    fileprivate func getItemController(_ itemIndex: Int) -> ScrollablePageItemController? {

        if itemIndex < contentImageURLs.count {
            let scrollablePageItemController = storyboard!.instantiateViewController(withIdentifier: "ScrollablePageItemController") as! ScrollablePageItemController
            scrollablePageItemController.itemIndex = itemIndex
            scrollablePageItemController.productImageURL = contentImageURLs[scrollablePageItemController.itemIndex]
            
            return scrollablePageItemController
        }
        return nil
    }

    // MARK: - Page Indicator
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImageURLs.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pageIndicatorIndex
    }

    fileprivate func setupUI() {
        view.backgroundColor = .black
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageViewController(atIndex: pageIndicatorIndex)
        setupUI()
    }
    
    override var prefersStatusBarHidden : Bool { return true }

    /// A method fixing the bounds of the image so that page control with the dots does not cover that particular image when a user zooms in.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = .clear
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension ScrollablePageViewController: UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard contentImageURLs.count > 0 else { return nil }

        let itemController = viewController as! ScrollablePageItemController

        let nextIndex = itemController.itemIndex > 0 ? (itemController.itemIndex - 1) : (contentImageURLs.count - 1)
        return getItemController(nextIndex)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard contentImageURLs.count > 0 else { return nil }

        let itemController = viewController as! ScrollablePageItemController

        let previousIndex = itemController.itemIndex + 1 < contentImageURLs.count ? (itemController.itemIndex + 1) : (0)
        return getItemController(previousIndex)
    }
}

