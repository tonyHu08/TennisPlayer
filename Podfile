platform :ios, '12.1'

target 'TennisPlayer' do
pod 'AVOSCloud'
end

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
end
end
end
end

inhibit_all_warnings!

