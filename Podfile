# Uncomment the next line to define a global platform for your project
install! 'cocoapods', :warn_for_unused_master_specs_repo => false
platform :ios, '15.0'

target 'my_app_ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for my_app_ios
	pod 'GoogleMaps'
	#swift
	pod 'FirebaseCore'
	pod 'FirebaseAuth'
	pod 'FirebaseDatabase'
	pod 'FirebaseMessaging'
	pod 'FirebaseStorage'
	
	pod 'FBSDKCoreKit'
	pod 'FBSDKLoginKit'
	
	pod 'STTwitter'
	#pod 'InstagramKit'
	
	pod 'SQLCipher'
	pod 'SSZipArchive'
	pod 'GDataXML-HTML'
	pod 'AESCrypt'
	pod 'CryptoSwift'
	pod 'NSHash'
	pod 'Alamofire'
	pod 'SwiftLint'
	pod 'Kingfisher'
	pod 'Realm'
	#object c
	pod 'DTTJailbreakDetection'
	pod 'SDWebImage'
	pod 'DGActivityIndicatorView'
	
  target 'my_app_iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'my_app_iosUITests' do
    # Pods for testing
  end
	post_install do |installer|
			installer.generated_projects.each do |project|
						project.targets.each do |target|
								target.build_configurations.each do |config|
										config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
								 end
						end
		 end
	end
end
