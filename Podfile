# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'MoViesC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MoViesC
  pod 'Alamofire', '~>5.0.0-rc.2'
  pod 'ObjectMapper'
  pod 'AlamofireObjectMapper'

  pod 'SwiftLint', '0.43.1'
  pod 'Kingfisher', '~> 6.0'
  pod 'MultiPeer', '~> 0.2.0'
  pod 'IQKeyboardManagerSwift', '~> 6.0'
  pod 'SwiftMessages'
  pod 'SwiftKeychainWrapper'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.0"
      end
    end
  end

end
