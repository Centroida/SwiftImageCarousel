import UIKit

//
//  AppDelegate.swift
//  SwiftImageCarousel
//
//  Created by Deyan Aleksandrov on 12/30/16.
//  Copyright © 2016 Deyan Aleksandrov. All rights reserved.
//

public var imageCache = NSCache<NSString, UIImage>()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        imageCache.totalCostLimit = 500 // number of images cached
        imageCache.removeAllObjects()

        // Override point for customization after application launch.
        return true
    }
}

