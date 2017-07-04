//
//  SwiftImageCarouselGalleryVCTests.swift
//  SwiftImageCarousel
//
//  Created by Veronika Hristozova on 2/11/17.
//  Copyright © 2017 ceontroida. All rights reserved.
//

import XCTest
@testable import SwiftImageCarousel

class SwiftImageCarouselGalleryVCTests: XCTestCase {
    
    var vc: GalleryVC!
    var contentImageURLs: [String]!
    
    override func setUp() {
        super.setUp()
        contentImageURLs = [String](repeating: "m", count: 100)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: GalleryVC.self))
        vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
        
        vc.contentImageURLs = contentImageURLs
        let _ = vc.view
        vc.viewDidLayoutSubviews()
        let _ = vc.prefersStatusBarHidden
    }

    override func tearDown() {
        vc = nil
        contentImageURLs = nil
        super.tearDown()
    }
    
    func testLoadPageVC() {        
        vc.loadPageViewController(atIndex: 0)
        let first = vc.viewControllers?.first as? GalleryItemVC
        
        XCTAssertEqual(first?.productImageURL, contentImageURLs[0])
    }
    
    func testPageVCAfter() {
        let pageViewController = GalleryVC()
        let viewController = GalleryItemVC()
        XCTAssertNotNil(vc.pageViewController(pageViewController, viewControllerAfter: viewController))
        
        vc.contentImageURLs.removeAll()
        vc.contentImageURLs.append("oneURL")
        XCTAssertNil(vc.pageViewController(pageViewController, viewControllerAfter: viewController))
        
    }
    
    func testPageVCBefore() {
        let pageViewController = GalleryVC()
        let viewController = GalleryItemVC()
        XCTAssertNotNil(vc.pageViewController(pageViewController, viewControllerBefore: viewController))
        
        vc.contentImageURLs.removeAll()
        vc.contentImageURLs.append("oneURL")
        XCTAssertNil(vc.pageViewController(pageViewController, viewControllerBefore: viewController))
    }
}
