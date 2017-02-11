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
    var contentImageURLs = [String]()
    
    override func setUp() {
        super.setUp()
        
        contentImageURLs = [String](repeating: "<URL STRING>", count: 100)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        
        vc.contentImageURLs = contentImageURLs
    }
    
    func testSettingViewControllersURL() {
        for i in 0..<100 {
            vc.loadPageViewController(atIndex: i)
            
            let firstViewController = vc.viewControllers?.first as? SwiftImageCarouselItemVC
            XCTAssertNotNil(firstViewController, "Couldn't get \(i)th view controller")
            let firstViewControllerItemIndex = firstViewController!.itemIndex
            XCTAssert(firstViewController!.contentImageURLs[firstViewControllerItemIndex] == contentImageURLs[i])
        }
    }
    
    func testloadPageViewControllerPerformance() {
        measure {
            self.vc.loadPageViewController()
        }
    }
}
