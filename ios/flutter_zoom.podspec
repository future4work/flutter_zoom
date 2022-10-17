
Pod::Spec.new do |s|
  s.name             = 'flutter_zoom'
  s.version          = '0.0.1'
  s.summary          = 'Flutter wrapper for Zoom SDK.'
  s.description      = <<-DESC
Flutter wrapper for the Zoom client-side SDK. Targeting iOS and Android (soon), with web and MacOS as nice-to-have.
                       DESC
  s.homepage         = 'http://future.work'
  s.author           = { 'FUTURE' => 'ext-account@future.work' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.preserve_paths = 'MobileRTC*.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework MobileRTC -framework MobileRTCScreenShare' }
  s.vendored_frameworks = 'MobileRTC.xcframework', 'MobileRTCScreenShare.xcframework'

  s.resources = 'MobileRTCResources.bundle'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
