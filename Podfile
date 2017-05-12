# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Evrythng-iOS-SampleApp' do

    workspace 'Evrythng-iOS-SampleApp.xcworkspace'
    xcodeproj 'Evrythng-iOS-SampleApp.xcodeproj’

  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Evrythng-iOS-SampleApp
  #pod 'EvrythngiOS', :git => 'https://github.com/imfree-jdcastro/Evrythng-iOS-SDK.git', :tag => '0.0.211'
  #pod 'EvrythngiOS', :path => '~/Desktop/Development/XcodeProjects/EvrythngiOS/EvrythngiOS.podspec'

  target 'Evrythng-iOS-SampleAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Evrythng-iOS-SampleAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'EvrythngiOS' do
  workspace 'Evrythng-iOS-SampleApp.xcworkspace'
  xcodeproj 'EvrythngiOS/EvrythngiOS.xcodeproj’

   # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for EvrythngiOS
    pod 'Alamofire', '~> 4.4'
    pod 'AlamofireObjectMapper', '~> 4.1'
    pod 'Moya', '~> 8.0.3'
    pod 'MoyaSugar', '~> 0.4'
    pod 'Moya-SwiftyJSONMapper', '~> 2.2'
    pod 'Moya-ObjectMapper' '~> 2.3.1'
    pod 'SwiftyJSON', '~> 3.1'
    pod 'SwiftEventBus', '~> 2.1'
    pod 'QRCodeReader.swift', '~> 7.4.1'

  end
