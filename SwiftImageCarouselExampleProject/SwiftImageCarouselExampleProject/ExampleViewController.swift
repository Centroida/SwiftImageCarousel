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
    var imageURLs = ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEk1nFxHenk7Mjlu0j25zlRobxzos707fsGuruD5ZDlHSzaAA7", "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTxbyrtvNkjkgJ2a3KxOjNSq5-T5233hxtN86B2QD3NUaPFid4Vyg", "https://s-media-cache-ak0.pinimg.com/originals/c0/6d/b9/c06db90191ec07e7c7d24a99cf34afd3.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        vc.contentImageURLs = imageURLs
        
        // Adding it to the container view
        vc.willMove(toParentViewController: self)
        containerView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
    
}
