
Pod::Spec.new do |s|
  s.name             = 'flutter_zoom'
  s.version          = '0.0.1'
  s.summary          = 'Flutter wrapper for Zoom SDK.'
  s.description      = <<-DESC
Flutter wrapper for the Zoom client-side SDK. Targeting iOS and Android (soon), with web and MacOS as nice-to-have later.
                       DESC
  s.homepage         = 'http://future.work'
  s.author           = { 'FUTURE' => 'ext-account@future.work' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.preserve_paths   = 'Libraries/**/*'
  s.platform         = :ios, '9.0'
  s.dependency       'Flutter'

  s.pod_target_xcconfig = {
      'DEFINES_MODULE' => 'YES',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64',
      'OTHER_LDFLAGS' => '-ObjC -l"c++"',
      'ENABLE_BITCODE' => 'NO'
  }
  s.swift_version = '5.0'

  s.frameworks = 'VideoToolbox'
  s.vendored_frameworks = 'Libraries/MobileRTC.xcframework', 'Libraries/MobileRTCScreenShare.xcframework'
  s.resource = 'Libraries/MobileRTCResources.bundle'
end
