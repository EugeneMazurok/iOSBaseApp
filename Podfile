# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

  swift_version = "5.0"
  platform :ios, '12.0'

target 'BaseGalleryProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BaseGalleryProject
  pod 'RxNetworkApiClient', :inhibit_warnings => true
  pod 'RxSwift', '~> 5.0.1' # обусловлено требованиями апиклиента
  pod 'SwiftyJSON', :inhibit_warnings => true
  pod 'DITranquillity', :inhibit_warnings => true
  pod 'R.swift', :inhibit_warnings => true
  pod "DBDebugToolkit", :inhibit_warnings => true

  post_install do |installer_representation|
      installer_representation.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
              config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
              config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
          end
      end
  end
end
