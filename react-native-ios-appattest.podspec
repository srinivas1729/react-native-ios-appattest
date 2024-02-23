# react-native-ios-appattest.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-ios-appattest"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-ios-appattest
                   DESC
  s.homepage     = "https://github.com/srinivas1729/react-native-ios-appattest"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Srinivas Visvanathan" => "25495739+srinivas1729@users.noreply.github.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/srinivas1729/react-native-ios-appattest.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,cc,cpp,m,mm,swift}"
  s.requires_arc = true

  s.dependency "React"
  # ...
  # s.dependency "..."
end

