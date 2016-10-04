Pod::Spec.new do |s|
  s.name             = "MMMSwiftAppUpdater"
  s.version          = "1.0.1"
  s.summary          = "Simple pod to check new version of application in Appstore"
  s.description      = "Simple class to check new version of app. You can simply check for new version of the app and open Appstore to let user to update."
  s.homepage         = "https://github.com/martinpilch/MMMSwiftAppUpdater"
  s.license          = 'MIT'
  s.author           = { "Martin Pilch" => "martin.pilch@email.cz" }
  s.source           = { :git => "https://github.com/martinpilch/MMMSwiftAppUpdater.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/martin_pilch'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'
end
