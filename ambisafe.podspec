#
# Be sure to run `pod lib lint ambisafe.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ambisafe"
  s.version          = "0.1.0"
  s.summary          = "iOs library used by Ambisafe.co for general purposes."
  s.description      = <<-DESC
    iOs library used by Ambisafe.co for general purposes related to accounts and transactions.
    DESC

  s.homepage         = "https://github.com/Ambisafe/client-ios"
  s.license          = 'MIT'
  s.author           = { "Charlie Fontana" => "charlie@ambisafe.co" }
  s.source           = { :git => "https://github.com/Ambisafe/client-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ambisafe' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
