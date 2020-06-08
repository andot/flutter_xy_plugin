#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_xy_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_xy_plugin'
  s.version          = '1.2.0'
  s.summary          = '新义互联广告 SDK Flutter 插件.'
  s.description      = <<-DESC
新义互联广告 SDK Flutter 插件.
                       DESC
  s.homepage         = 'https://github.com/adtalos/flutter_xy_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ma Bingyao' => 'mabingyao@adtalos.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AdtalosSDK', '~> 1.4.4'
  s.platform = :ios, '8.0'

  s.static_framework = true
end
