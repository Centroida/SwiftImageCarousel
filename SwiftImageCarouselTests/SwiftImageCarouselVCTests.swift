//
//  SwiftImageCarouselTests.swift
//  SwiftImageCarouselTests
//
//  Created by Deyan Aleksandrov on 1/12/17.
//  Copyright © 2017 ceontroida. All rights reserved.
//

import XCTest
@testable import SwiftImageCarousel

class SwiftImageCarouselVCTests: XCTestCase {
    
    var vc: SwiftImageCarouselVC!
    var testImagesURLsCount = 50
    var contentImageURLs = [String]()
    
    // MARK: - SetUp & TearDown
    override func setUp() {
        super.setUp()
        
        contentImageURLs = [String](repeating: "<URL STRING>", count: testImagesURLsCount)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        
        vc.contentImageURLs = contentImageURLs
        vc.loadPageViewController()
        let _ = vc.view
    }
    
    // MARK: - Tests
    func testSettingViewControllersURL() {
        for i in 0..<contentImageURLs.count {
            // When
            vc.loadPageViewController(atIndex: i)
            
            let firstViewController = vc.viewControllers?.first as! SwiftImageCarouselItemVC
            
            // Then
            XCTAssertEqual(firstViewController.contentImageURLs[firstViewController.itemIndex], contentImageURLs[i])
        }
    }
    
    func testGetItemController() {
        // Given
        let itemControllerIndex = 5
        
        // When
        let itemVC = vc.getItemController(itemControllerIndex)!
        let resetVC = vc.getItemController(vc.contentImageURLs.count)!
        
        // Then
        XCTAssertEqual(itemVC.itemIndex, itemControllerIndex)
        XCTAssertEqual(resetVC.itemIndex, 0)
    }
    
    func testGetItemControllerNoURLs() {
        // Given
        let itemControllerIndex = 0
        vc.contentImageURLs.removeAll()
        
        // When
        let itemVC = vc.getItemController(itemControllerIndex)
        
        // Then
        XCTAssertNil(itemVC)
    }
    
    func testGetNextItemController() {
        // When
        let firstVC = vc.viewControllers?.first as! SwiftImageCarouselItemVC
        let firstVCItemIndex = firstVC.itemIndex
        
        vc.getNextItemController()
        
        let secondVC = vc.viewControllers?.first as! SwiftImageCarouselItemVC
        let secondVCItemIndex = secondVC.itemIndex
        
        // Then
        XCTAssertEqual(firstVCItemIndex + 1, secondVCItemIndex)
    }
    
    func testGetPreviousItemController() {
        // Given
        let itemControllerIndex = 5
        
        // When
        let currentItemVC = vc.getItemController(itemControllerIndex)!
        let previousItemVC = vc.pageViewController(vc, viewControllerBefore: currentItemVC) as! SwiftImageCarouselItemVC
        
        // Then
        XCTAssertEqual(currentItemVC.itemIndex - 1, previousItemVC.itemIndex)
    }
    
    func testUnwindToSwiftImageCarouselVC() {
        // Given
        let itemIndexToUnwindFrom = 5
        
        // When
        vc.loadPageViewControllerWhenUnwinding(atIndex: itemIndexToUnwindFrom)
        let firstViewController = vc.viewControllers?.first as! SwiftImageCarouselItemVC
        
        // Then
        XCTAssertEqual(firstViewController.itemIndex, itemIndexToUnwindFrom)
    }
    
    // MARK: - Performance Tests
    func testloadPageViewControllerPerformance() {
        measure {
            self.vc.loadPageViewController()
        }
    }
}
