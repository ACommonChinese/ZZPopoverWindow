Pod::Spec.new do |s|

  s.name          = "ZZPopoverWindow"
  s.version       = "1.0.0"
  s.license       = "MIT"
  s.summary       = "Pop over in iOS."
  s.homepage      = "https://github.com/ACommonChinese"
  s.author        = { "ACommonChinese" => "liuxing8807@126.com" }
  s.source        = { :git => "https://github.com/ACommonChinese/ZZPopoverWindow.git", :tag => "1.0.0" }
  s.requires_arc  = true
  s.description   = <<-DESC
                   Fast encryption string, the current support for MD5 (16, 32), Sha1, Base64
                   DESC
  s.source_files  = "ZZPopoverWindow/*"
  s.platform      = :ios, '7.0'
  s.framework     = 'Foundation', 'CoreGraphics', 'UIKit'  

end