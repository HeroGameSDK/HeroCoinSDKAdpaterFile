

Pod::Spec.new do |spec|

  spec.name         = "HeroCoinSDKAdpaterFile"
  spec.version      = "0.0.4"
  spec.summary      = "游戏SDK Adpater文件"

  spec.description  = "Hero游戏SDK Adpater文件"

  spec.homepage     = "https://github.com/HeroGameSDK/HeroCoinSDKAdpaterFilePod"

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author             = { "huyunlong" => "yunlong.hu@timeltd.cn" }


  spec.platform     = :ios
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/HeroGameSDK/HeroCoinSDKAdpaterFilePod.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

  #spec.public_header_files = "Classes/**/*.h"

  #spec.resource  = "Assets/HeroCoinResources.bundle"
  #spec.vendored_frameworks = "Classes/*.framework"

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"


  spec.requires_arc = true


end
