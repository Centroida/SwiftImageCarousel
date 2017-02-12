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
    var imageURLs = ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEk1nFxHenk7Mjlu0j25zlRobxzos707fsGuruD5ZDlHSzaAA7", "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQwuyCKN_rcn0789gX7CTq3Z0-zVD0oaNIelWrMofrsryWYZJOX", "https://s-media-cache-ak0.pinimg.com/originals/c0/6d/b9/c06db90191ec07e7c7d24a99cf34afd3.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        _  = SwiftImageCarouselVC.instantiate(containerView: containerView, contentImageURLs: imageURLs, parentVC: self)
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

