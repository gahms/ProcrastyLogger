#
# Be sure to run `pod lib lint ProcrastyLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ProcrastyLogger"
  s.version          = "0.1.0"
  s.summary          = "Fast and simple logging for iOS."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  Fast and simple logging for iOS. ProcrastyLogger offers fast and easy logging
  to the console or to a set of rolling files. Log levels can be configured and
  changed without recompiling. Disabled logs are very fast.
                       DESC

  s.homepage         = "https://github.com/gahms/ProcrastyLogger"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Nicolai Henriksen" => "nicolai@procrasty.com" }
  s.source           = { :git => "https://github.com/gahms/ProcrastyLogger.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'PLog/**/*'
  s.resource_bundles = {
    'ProcrastyLogger' => ['PLog/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'ZipArchive', '~> 1.4'
end
