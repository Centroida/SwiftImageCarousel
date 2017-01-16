Pod::Spec.new do |s|

 s.platform = :ios
  s.ios.deployment_target = ’10.0’
  s.name = "SwiftImageCarousel"
  s.summary = "SwiftImageCarousel is an easy-to-use carousel."
  s.requires_arc = true

 s.version = “0.0.1”

  s.homepage     = "https://github.com/Centroida/SwiftImageCarousel"

  s.license      = "MIT"

 s.authors    = { "Deyan Aleksandrov" => "deyanaaleksandrov@gmail.com”, “Gavril Tonev” => “gtonev@centroida.co” }


  s.source       = { :git => "https://github.com/Centroida/SwiftImageCarousel.git”, :tag => “0.0.1” }

  s.source_files  = "SwiftImageCarousel", "SwiftImageCarousel/**/*.{h,m,swift}”

 s.resource  = "SwiftImageCarousel", "SwiftImageCarousel/**/*.{h,m,swift,storyboard,png}”
end
