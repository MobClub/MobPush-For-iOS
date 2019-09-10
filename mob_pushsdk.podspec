Pod::Spec.new do |s|
  s.name                  = 'mob_pushsdk'
  s.version               = "2.2.0"
  s.summary               = 'mob.com 官方提供的推送SDK'
  s.license               = 'MIT'
  s.author                = { "mob" => "mobproducts@163.com" }

  s.homepage              = 'http://www.mob.com'
  s.source                = { :http => 'https://dev.ios.mob.com/files/download/pushsdk/MobPush_For_iOS_v2.2.0.zip' }
  s.platform              = :ios
  s.ios.deployment_target = "8.0"
  s.default_subspecs      = 'MobPush'
  s.dependency 'MOBFoundation'
  s.static_framework = true

  s.subspec 'MobPush' do |sp|
      sp.vendored_frameworks   = 'MobPush/MobPush.framework','MobPush/MobPushServiceExtension.framework'
  end

end
