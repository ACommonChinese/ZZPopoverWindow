#
# Be sure to run `pod lib lint ZZPopoverWindow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'ZZPopoverWindow'
  s.version      = '1.0.1'
  s.summary      = 'Pop over view in iOS '
  s.description  = 'ZZPopoverWindow is a convenience tool of popover view iOS/Objective-C'
  s.homepage     = 'https://github.com/liuxing8807@126.com/ZZPopoverWindow'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "ACommonChinese" => "liuxing8807@126.com" }
  s.source       = { :git => 'https://github.com/liuxing8807@126.com/ZZPopoverWindow.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.source_files = 'ZZPopoverWindow/Classes/**/*'
  s.framework    = 'Foundation', 'CoreGraphics', 'UIKit'
end
