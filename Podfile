# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

target 'App_todo_ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Floaty', '~> 4.2.0'
  pod 'MPInjector'
  pod 'PaddingLabel', '1.2'
  pod 'KeychainAccess'


  # Pods for App_todo_ios

  target 'App_todo_iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'App_todo_iosUITests' do
    # Pods for testing
  end

end
