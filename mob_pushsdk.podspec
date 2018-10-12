Pod::Spec.new do |s|
  s.name                  = 'mob_pushsdk'
  s.version               = "1.5.0"
  s.summary               = 'mob.com 官方提供的推送SDK'
  s.license               = 'MIT'
  s.author                = { "mob" => "mobproducts@163.com" }

  s.homepage              = 'http://www.mob.com'
  s.source                = { :git => "https://github.com/MobClub/MobPush-For-iOS.git", :tag => s.version.to_s }
  s.platform              = :ios
  s.ios.deployment_target = "8.0"
  s.default_subspecs      = 'MobPush'
  s.dependency 'MOBFoundation'

  s.subspec 'MobPush' do |sp|
      sp.vendored_frameworks   = 'SDK/MobPush/MobPush.framework'
      sp.vendored_frameworks   = 'SDK/MobPush/MobPushServiceExtension.framework'
  end

end
