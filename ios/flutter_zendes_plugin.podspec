#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_zendes_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_zendes_plugin'
  s.version          = '0.0.3'
  s.summary          = 'A Zendes Flutter plugin.'
  s.description      = <<-DESC
A Zendes Flutter plugin.
                       DESC
  s.homepage         = 'http://hellojasper.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jasper' => 'dd.dyach@gmail.com' }
  s.source           = { :path => '.' }  
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.static_framework = true
  
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }

  s.swift_version = '5.0'
  #s.dependency 'ZendeskSupportSDK'
  s.dependency 'ZendeskSupportProvidersSDK'
  #s.dependency 'ZendeskSDKMessaging'
  
  s.dependency 'ZendeskAnswerBotSDK' # AnswerBot-only on the Unified SDK
 
  #s.dependency 'ZDCChat'
  s.dependency 'ZendeskSupportSDK'
  #s.dependency 'ZendeskSDKSocketClient', '0.4.2'
  
 #s.ios.vendored_frameworks = '~/Users/dmitrydyachenko/Downloads/zdplugin/ios/chat_sdk_ios-master/ZendeskChatSDK.framework', '~/Users/dmitrydyachenko/Downloads/zdplugin/ios/chat_providers_sdk_ios-master/ZendeskChatProvidersSDK.framework'

  #s.vendored_frameworks = '~/Users/dmitrydyachenko/Downloads/zdplugin/ios/chat_sdk_ios-master/ZendeskChatSDK.framework', '~/Users/dmitrydyachenko/Downloads/zdplugin/ios/chat_providers_sdk_ios-master/ZendeskChatProvidersSDK.framework'
  #s.source = { :git => 'file:///Users/dmitrydyachenko/Downloads/zdplugin/ios/chat_sdk_ios-master/'}
  #s.dependency 'ZendeskChatProvidersSDK'
  s.dependency 'ZendeskChatSDK'#, '2.11.1'
  
  s.subspec 'ZendeskChatSDK' do |ss| 
   ss.source_files = '~/Users/dmitrydyachenko/Downloads/zdplugin/ios/chat_sdk_ios-master/ChatSDK.framework/**/*.{h,m}' 
  end

  s.subspec 'ZendeskChatProvidersSDK' do |ss| 
    ss.source_files = '~/Users/dmitrydyachenko/Downloads/zdplugin/ios/chat_providers_sdk_ios-master/ChatProvidersSDK.framework/**/*.{h,m}' 
  end
  
end
