Pod::Spec.new do |s|

  s.name         = "GQImageVideoViewer"
  s.version      = "0.0.1"
  s.summary      = "一款仿微信多图片及视频浏览器，图片和视频原尺寸显示，不会变形，双击图片放大缩小，单击消失，支持多张本地和网络图片以及网络视频混合查看，支持链式调用。"

  s.homepage     = "https://github.com/g763007297/GQImageVideoViewer"
  # s.screenshots  = "https://github.com/g763007297/GQImageVideoViewer/blob/master/Screenshot/demo.gif"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "developer_高" => "763007297@qq.com" }
  
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/g763007297/GQImageVideoViewer.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.source_files  = "GQImageVideoViewer/**/*.{h,m}"

  #s.public_header_files = "GQImageVideoViewer/**/*.h"

end
