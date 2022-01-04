#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint baidu_ocr_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'baidu_ocr_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  # s.libraries           = ['c++']
  # s.subspec 'AipBase' do |b|
  #   b.vendored_frameworks ='aip-ocr-ios-sdk-3.0.5/lib/AipBase.framework'
  # end

  # s.subspec 'AipOcrSdk' do |s|
  #     s.vendored_frameworks ='aip-ocr-ios-sdk-3.0.5/lib/AipOcrSdk.framework'
  # end

  # s.subspec 'IdcardQuality' do |i|
  #     i.vendored_frameworks ='aip-ocr-ios-sdk-3.0.5/lib/IdcardQuality.framework'
  # end

  # s.libraries    = ['c++']
  # s.ios.vendored_frameworks = 'aip-ocr-ios-sdk-3.0.5/lib/*.framework'
  # s.vendored_frameworks = 'AipBase.framework', 'AipOcrSdk.framework', 'IdcardQuality.framework'
  s.vendored_frameworks = 'aip-ocr-ios-sdk-3.0.5/lib/AipBase.framework', 'aip-ocr-ios-sdk-3.0.5/lib/AipOcrSdk.framework', 'aip-ocr-ios-sdk-3.0.5/lib/IdcardQuality.framework'
end
