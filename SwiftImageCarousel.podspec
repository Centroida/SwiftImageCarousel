Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SwiftImageCarousel"
  s.version      = “1.0.0”
  s.summary      = "SwiftImageCarousel is an easy-to-use carousel that supports scrolling, automatic timer swiping and full screen viewing with zoom.”

  s.description  = <<-DESC
This is a simple image carousel for Swift that works with provided image URLs (they get downloaded asynchronously for you). You do not have to rely on hardcoded images or care about dispatch queues and etc! What could be better than that? Eh, ok, you have to decide how the page control dots will look like. Not so much work, still :)

Why did we do it? We decided to create this framework to make our lives at the company and other Swift developers’ lives easier when in the need of an easy-to-use carousel for any iOS device project. 

The focus we put is on the simplicity to use and division of concerns - you provide the URLs for the images, let the SwiftImageCarousel framework do the rest, be certain it will do things right.
                   DESC

  s.homepage     = "https://github.com/Centroida/SwiftImageCarousel"
  s.screenshots  = “http://giphy.com/gifs/OKjor8B8Yixxe”, ”http://makeagif.com/BulSQI", "http://makeagif.com/KlKnn2”

  s.license      = "MIT"

  s.author             = { "Deyan Aleksandrov" => "deyanaaleksandrov@gmail.com" }
  s.authors            = { “Gavril Tonev” => “gtonev@centroida.co” }

  s.platform     = :ios
  s.platform     = :ios, “10.0”

  s.source       = { :git => “https://github.com/Centroida/SwiftImageCarousel”, tag: => “1.0.0” }

  s.source_files  = “SwiftImageCarousel”, "SwiftImageCarousel/**/*.{h,m,swift,storyboard}”

  s.resource  = “SwiftImageCarousel/*.png"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
