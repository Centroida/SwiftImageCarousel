# SwiftImageCarousel
 
SwiftImageCarousel is a UIPageController-based framework that implements scrolling, zooming and automatic swiping carousel in a Swift applicatoion.

All it needs from you is to supply it with valid image URLs and it is good to go. 

## Preview

![](http://i.giphy.com/AetMTdLtlwn72.gif)   

## Features

- Horizontal image swiping that can be pinched and zoomed.
- A timer to make the horizontal image swiping automatic.
- Asynchronous image downloading that does not block the main thread. All you have to do is provide the URLs.
- Customizable page controls appearance (the dot colors and background) -they can be set up through delegate protocol.

## Installation 

### CocoaPods 

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To integrate SwiftImageCarousel into your Xcode project using CocoaPods, specify it in your ```Podfile```:

```
source 'https://github.com/Centroida/SwiftImageCarousel.git'

platform :ios, '10.0'
use_frameworks!

target '<Your Target Project Name>' do
pod 'SwiftImageCarousel', '1.0.1'
end

```

### Alternatively:

- Git submodule add https://github.com/Centroida/SwiftImageCarousel.git.
- Drag the SwiftImageCarousel.xcodeproj file into your Xcode project (Xcode will ask to create a workspace file if your project does not have one already)
- Under the main app target, open the General tab and add SwiftImageCarousel under the Embedded Binaries section
- Build the SwiftImageCarousel as a target before you import it
- It is ready to be imported and used

<b>OR</b>

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
### Providing the images as URLs and instantiating a VC with carousel that takes over the screen

Make sure you do this in viewDidAppear(),because it will not work in viewDidLoad().

```swift   
import UIKit
import SwiftImageCarousel

class RandomViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let s = UIStoryboard (name: "Main", bundle: Bundle(for: InitialPageViewController.self))
        let vc = s.instantiateInitialViewController() as! InitialPageViewController
        vc.contentImageURLs = [ "<Your First URL>", "<Your Second URL>", "<Your Third URL>"]

        self.present(vc, animated: true, completion: nil)
    }
    
}
```


### Providing the images as URLs and embedding the carousel

```swift
    ///  The UIView declared in Main.Storyboard.
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let s = UIStoryboard (name: "Main", bundle: Bundle(for: InitialPageViewController.self))
        let vc = s.instantiateInitialViewController() as! InitialPageViewController

        vc.contentImageURLs = ["<Your First URL>", "<Your Second URL>", "<Your Third URL>"]

        // Lets add it to container view.
        vc.willMove(toParentViewController: self)
        containerView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
```

### Setting up the <i>contentImageURLs</i> STRING ARRAY with image URLs provided as STRINGS

```swift
       let s = UIStoryboard (name: "Main", bundle: Bundle(for: InitialPageViewController.self))
       let vc = s.instantiateInitialViewController() as! InitialPageViewController
       
       /// Default URLs are not provided. They need to be set up.
       vc.contentImageURLs = [ "<Your First URL>", "<Your Second URL>", "<Your Third URL>"]
```

### Disabling the timer with the <i>isTimerOn</i> BOOLEAN variable

```swift
       let s = UIStoryboard (name: "Main", bundle: Bundle(for: InitialPageViewController.self))
       let vc = s.instantiateInitialViewController() as! InitialPageViewController
       
       /// Timer ON/OFF boolean variable. Timer for automatic swiping is set true(or ON) by default. If it needs to be off, it needs to be set to false.
       vc.isTimerOn = false
```

### Changing the timer's automatic swipe interval with the <i>swipeTimeIntervalSeconds</i> DOUBLE variable

```swift
       let s = UIStoryboard (name: "Main", bundle: Bundle(for: InitialPageViewController.self))
       let vc = s.instantiateInitialViewController() as! InitialPageViewController
       
       /// The interval on which the carousel swipes automatically when timer is on. Default is 3 seconds.
       vc.swipeTimeIntervalSeconds = 1.5
```

### Setting up the InitialPageViewControllerDelegate

After you create InitialPageViewController programatically, setup the pageVCDelegate to self:

```swift
       let s = UIStoryboard (name: "Main", bundle: Bundle(for: InitialPageViewController.self))
       let vc = s.instantiateInitialViewController() as! InitialPageViewController
       vc.pageVCDelegate = self
```

And do not forget to add InitialPageViewControllerDelegate as an extention to your custom-class View Controller:

```swift
        extension RandomViewController: InitialPageViewControllerDelegate {} 
```
 
### Delegate Functions Implementation after setting up the InitialPageViewControllerDelegate

<b>Setting up the appearance of the page controls (the ones with the colored dots)</b>

```swift
extension RandomViewController: InitialPageViewControllerDelegate {
    func setupAppearance(forFirst firstPageControl: UIPageControl, forSecond secondPageControl: UIPageControl) {
        firstPageControl.backgroundColor = .red
        firstPageControl.currentPageIndicatorTintColor = .yellow
    }
}
```

<b>Getting the timer and its properties in case they are needed for whatever reasons</b>

```swift
extension RandomViewController: InitialPageViewControllerDelegate {
    func didStartTimer(_ timer: Timer) {
        print (timer.timeInterval)
    }
}
```

<b>Getting the coming pageItemController and its properties when the timer is on</b>

```swift
extension RandomViewController: InitialPageViewControllerDelegate {
     func didGetNextITemController(next pageItemController: InitialPageItemController) {
        pageItemController.view.backgroundColor = .green
    }
}
```

<b>Getting gives you the pageItemController when unwinding from ScrollablePageItemController.</b>

```swift
extension RandomViewController: InitialPageViewControllerDelegate {
     func didUnwindToPageViewController(unwindedTo pageItemController: InitialPageItemController) {
        pageItemController.view.backgroundColor = .green
    }
}
```
  
## Known Issues
  
- Changing contentImageURLs should update the carousel.
 
 <b>Any more of these are welcomed!</b>  
  
## Requirements
  
SwiftImageCarousel was tested and is working with the latest available version of software - XCode Version 8.2.1 and Swift 3.0.
  
## License

SwiftImageCarousel is released under the MIT license. See LICENSE for details.
