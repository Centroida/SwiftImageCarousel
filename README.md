[![Travis branch](https://img.shields.io/travis/rust-lang/rust/master.svg?style=plastic)](https://github.com/Centroida/SwiftImageCarousel)
[![codecov.io](https://codecov.io/gh/Centroida/SwiftImageCarousel/coverage.svg?branch=master?style=plastic)](https://codecov.io/gh/Centroida/SwiftImageCarousel?branch=master)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftImageCarousel.svg?style=plastic)](https://img.shields.io/cocoapods/v/SwiftImageCarousel.svg)
[![CocoaPods](https://img.shields.io/cocoapods/dt/SwiftImageCarousel.svg?style=plastic)](https://github.com/Centroida/SwiftImageCarousel)
[![Platform](https://img.shields.io/cocoapods/p/SwiftImageCarousel.svg?style=plastic)](http://cocoadocs.org/docsets/SwiftImageCarousel)
[![CocoaPods](https://img.shields.io/cocoapods/l/SwiftImageCarousel.svg?style=plastic)](https://img.shields.io/cocoapods/l/SwiftImageCarousel.svg)

# SwiftImageCarousel
 
SwiftImageCarousel is a UIPageController-based framework that implements scrolling, zooming and automatic swiping carousel in a Swift application. All it needs from you is to supply it with valid image URLs and it is good to go. 

- [Preview](#preview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)


## Preview

![](http://i.giphy.com/AetMTdLtlwn72.gif)   

## Features

- Horizontal image swiping that can be pinched and zoomed.
- A timer to make the horizontal image swiping automatic.
- Asynchronous image downloading that does not block the main thread. All you have to do is provide the URLs.
- Customizable page controls appearance (the dot colors and background) -they can be set up through delegate protocol.

## Requirements

- iOS 9.0+
- Swift 3.0+

## Installation 

### CocoaPods 

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To integrate SwiftImageCarousel into your Xcode project using CocoaPods, specify it in your ```Podfile```:

```swift

target '<Your Target Project Name>' do
use_frameworks!

pod 'SwiftImageCarousel'
end

```

### Alternatively:

- Git submodule add https://github.com/Centroida/SwiftImageCarousel.git.
- Drag the SwiftImageCarousel.xcodeproj file into your Xcode project (Xcode will ask to create a workspace file if your project does not have one already)
- Under the main app target, open the General tab and add SwiftImageCarousel under the Embedded Binaries section
- Build the SwiftImageCarousel as a target before you import it
- It is ready to be imported and used

<b>Or</b>

- Download directly from the github link https://github.com/Centroida/SwiftImageCarousel
- Run your project, right click on the name of your project in the files navigator and choose "Add Files to <i>NameOfYourProject</i>"
- Find SwiftImageCarousel.xcodeproj and add it
- Under the main app target, open the General tab and add SwiftImageCarousel under the Embedded Binaries section
- Build the SwiftImageCarousel as a target before you import it
- It is ready to be imported and used

## Usage

### Importing the framework 

```swift
import SwiftImageCarousel
```

### Providing the images as URLs and embedding the `SwiftImageCarousel` in a UIContainerViewController

```swift
    ///  A UIView declared in Main.Storyboard.
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        vc.contentImageURLs = ["<Your First URL>", "<Your Second URL>", "<Your Third URL>"]

        // Adding it to the container view
        vc.willMove(toParentViewController: self)
        containerView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
```

### Setting up the `contentImageURLs` Array with image URLs provided as Strings

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       
       /// Default URLs are not provided. They need to be set up.
       vc.contentImageURLs = [ "<Your First URL>", "<Your Second URL>", "<Your Third URL>"]
```

### Setting up the `noImage` UIImage variable

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       
       // There is no default image for this variable. It needs to be set up.
       vc.noImage = <Some UIImage from the Assets in your project>
```

### Disabling the timer with the `isTimerOn` Bool variable

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       
       /// Timer ON/OFF boolean variable. Timer for automatic swiping is set true(or ON) by default. If it needs to be off, it needs to be set to false.
       vc.isTimerOn = false
```

### Changing the timer's automatic swipe interval with the `swipeTimeIntervalSeconds` Double variable

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       
       /// The interval on which the carousel swipes automatically when timer is on. Default is 3 seconds.
       vc.swipeTimeIntervalSeconds = 1.5
```

### Changing the SwiftImageCarouselItemVC content mode for image representation with the `contentMode` UIViewContentMode variable

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       
       /// Enables resetting the UIViewContentMode of SwiftImageCarouselItemVC UIViewContentMode. The default is .scaleAspectFit
       vc.contentMode = .scaleToFill
```

### Making sure that the UIPageControl background is transparent (page control dots remain visible) and the UIPageControl frame does not interfere with the images frame when in the carousel mode where images automatically switch (`SwiftImageCarouselVC`) using `escapeFirstPageControlDefaultFrame` Bool varaible:

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       
       /// The default value of the variable is false
       vc.escapeFirstPageControlDefaultFrame = true
```

###  Disabling the modal gallery segue transition from SwiftImageCarouselItemVC to GalleryVC with the `showModalGalleryOnTap` Bool variable 

This variable would usually be used in combination with the `didTapSwiftImageCarouselItemVC(SwiftImageCarouselItemController: SwiftImageCarouselItemVC)` SwiftImageCarouselVCDelegate function.

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       
       /// Enables/disables the showing of the modal gallery
       vc.showModalGalleryOnTap = false
```

### Setting up the SwiftImageCarouselVCDelegate

After you create `SwiftImageCarouselVC` programatically, setup the swiftImageCarouselVCDelegate to self:

```swift
       let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
       let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
       vc.swiftImageCarouselVCDelegate = self
```
 
### Delegate Functions Implementation after setting up the `SwiftImageCarouselVCDelegate`

<b>Setting <i>showModalGalleryOnTap</i> to false and instead performing a different segue than the default one when clicking on one of the images in the carousel.</b>

```swift
       /// Enables/disables the showing of the modal gallery
       vc.showModalGalleryOnTap = false 
```

```swift
extension ViewController: SwiftImageCarouselVCDelegate {
     func didTapSwiftImageCarouselItemVC(swiftImageCarouselItemController: SwiftImageCarouselItemVC) {
        // The user selected this swiftImageCarouselItemController
    }
}
``` 

<b>Setting up the appearance of the page controls (colored dots)</b>

```swift
extension ViewController: SwiftImageCarouselVCDelegate {
    func setupAppearance(forFirst firstPageControl: UIPageControl, forSecond secondPageControl: UIPageControl) {
        firstPageControl.backgroundColor = .red
        firstPageControl.currentPageIndicatorTintColor = .yellow
    }
}
```

<b>Getting the timer and its properties</b>

```swift
extension ViewController: SwiftImageCarouselVCDelegate {
    func didStartTimer(_ timer: Timer) {
        print (timer.timeInterval)
    }
}
```

<b>Getting the next pageItemController when the timer is on</b>

```swift
extension ViewController: SwiftImageCarouselVCDelegate {
     func didGetNextITemController(next pageItemController: InitialPageItemController) {
        pageItemController.view.backgroundColor = .green
    }
}
```

<b>Getting the pageItemController when unwinding from ScrollablePageItemController</b>

```swift
extension ViewController: SwiftImageCarouselVCDelegate {
     func didUnwindToPageViewController(unwindedTo pageItemController: InitialPageItemController) {
        pageItemController.view.backgroundColor = .green
    }
}
```
  
  
## License

SwiftImageCarousel is released under the MIT license. See LICENSE for details.
