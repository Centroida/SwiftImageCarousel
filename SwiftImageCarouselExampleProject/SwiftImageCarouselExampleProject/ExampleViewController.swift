//
//  ViewController.swift
//  SwiftImageCarouselExampleProject
//
//  Created by Deyan Aleksandrov on 2/12/17.
//  Copyright © 2017 Centroida. All rights reserved.
//

import SwiftImageCarousel
import UIKit

class ExampleViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    var imageURLs = [
        "https://store.storeimages.cdn-apple.com/4974/as-images.apple.com/is/image/AppleInc/aos/published/images/M/AC/MACBOOKPRO/MACBOOKPRO?wid=1200&hei=630&fmt=jpeg&qlt=95&op_sharpen=0&resMode=bicub&op_usm=0.5,0.5,0,0&iccEmbed=0&layer=comp&.v=6xyk93",
        "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTxbyrtvNkjkgJ2a3KxOjNSq5-T5233hxtN86B2QD3NUaPFid4Vyg",
        "https://s-media-cache-ak0.pinimg.com/originals/c0/6d/b9/c06db90191ec07e7c7d24a99cf34afd3.jpg"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        vc.contentImageURLs = imageURLs

        vc.showCloseButtonInModalGallery = true

        // Add delegate
        vc.swiftImageCarouselVCDelegate = self
        
        // Adding it to the container view
        vc.willMove(toParentViewController: self)
        containerView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
              }
    
}

extension ExampleViewController: SwiftImageCarouselVCDelegate {
    func setupAppearance(forFirst firstPageControl: UIPageControl, forSecond secondPageControl: UIPageControl) {
        
            firstPageControl.backgroundColor = .red
            firstPageControl.currentPageIndicatorTintColor = .yellow
        
        secondPageControl.backgroundColor = .yellow
        secondPageControl.currentPageIndicatorTintColor = .red
        
    }
    
    
    
}

