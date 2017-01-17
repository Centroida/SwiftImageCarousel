Pod::Spec.new do |s|
s.name         = "SwiftImageCarousel"
s.version      = “1.0.1”
s.summary      = "SwiftImageCarousel is an easy-to-use carousel."
s.description = "You are a swift developer and you want to implement a carousel in your app. And you want to do it fast with the option to scroll automatically and zoom too?
No need to search more but check out this UIPageViewController-based Swift Image Carousel!
All it needs from you is to supply it with valid image URLs and it is good to go."
s.authors    = { "Deyan Aleksandrov" => "deyanaaleksandrov@gmail.com", "Gavril Tonev" => "gtonev@centroida.co" }
s.homepage     = "https://github.com/Centroida/SwiftImageCarousel"
s.license      = "MIT"
s.platform     = :ios, "10"
s.source       = { :git => "https://github.com/Centroida/SwiftImageCarousel.git", :tag => "#{s.version}" }
s.source_files = "SwiftImageCarousel", "SwiftImageCarousel/**/*.{h,m,swift}"
s.resources = ["SwiftImageCarousel/**/*.storyboard"]
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
