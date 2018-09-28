#
#  Be sure to run `pod spec lint YSFPSStatus.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "YSFPSStatus"
  s.version      = "0.0.1"
  s.summary      = "show FPS status on StatusBar or custom"
  s.homepage     = "https://github.com/kysonyangs/YSFPSStatus"
  s.license      = "MIT"
  s.author       = { "kyson" => "kysonyangs@gmail.com" }
  s.source       = { :git => "https://github.com/kysonyangs/YSFPSStatus.git", :tag => "#{s.version}" }
  s.frameworks   = 'Foundation', 'UIKit'
  s.platform     = :ios, '7.0'
  s.source_files  = "YSFPSStatus/YSFPSStatus/*.{h,m}"
  s.requires_arc = true

end
