#
#  Be sure to run `pod spec lint TestPodSpec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "TestPodSpec"
  s.version      = "0.0.1"
  s.summary      = "A Test of PodSpec"
  s.description  = <<-DESC
                    "A Test of PodSpec"
                   DESC

  s.homepage     = "https://github.com/zhaochao89/TestPodSpec"
  s.license      = "MIT"
  s.author             = { "zhaochao89" => "zhaochao0801@sina.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zhaochao89/TestPodSpec.git", :tag => "0.0.1" }
  s.source_files = "TestPodSpec/*.h","TestPodSpec/*.{h,m}"
end
