
Pod::Spec.new do |s|
    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.author = {'xuyecan' => 'xuyecan@gmail.com'}
    s.license = 'Apache License 2.0'
    s.requires_arc = true
    s.version = '1.0.0'
    s.homepage = "https://github.com/alibaba/handyjson"
    s.name = "HandyJSON"

    s.source_files = 'HandyJSON/**/*.{swift,h,m}'
    s.source = { :git => 'https://github.com/alibaba/HandyJSON.git', :tag => s.version.to_s }

    s.summary = 'A Json Serialization & Deserialization Library for Swift'
    s.description = 'A Handy Json Library for Swift which serials object to json and deserials json to object'

    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
