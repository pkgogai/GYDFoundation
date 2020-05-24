
Pod::Spec.new do |s|
  s.name             = 'GYDFoundation'
  s.version          = '0.0.5'
  s.summary          = 'GYDFoundation'

  s.description      = <<-DESC
平时积累的一些代码，
也许有用，也许没用。
                       DESC

  s.homepage         = 'https://github.com/pkgogai/GYDFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pkgogai' => 'pkgogai@163.com' }
  s.source           = { :git => 'https://github.com/pkgogai/GYDFoundation.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.ios.requires_arc = true
  s.ios.framework = 'UIKit'
  
  s.default_subspec = ['GYDFoundation', 'GYDDatabase', 'GYDHTTPConnect', 'GYDJSONObject']
  
  #基础方法
  s.subspec 'GYDFoundation' do |ss|
    ss.ios.source_files = ['GYDFoundation/Code/Base/**/*','GYDFoundation/Code/iOS/**/*']
    ss.osx.source_files = ['GYDFoundation/Code/Base/**/*','GYDFoundation/Code/MacOS/**/*']
  end
  #数据库
  s.subspec 'GYDDatabase' do |ss|
    ss.source_files = 'GYDDatabase/Code/**/*'
    ss.dependency "FMDB"
    ss.dependency "GYDFoundation/GYDFoundation"
    ss.pod_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS'=>'GYD_FOUNDATION_USED_DATABASE=1'}
  end
  #http请求
  s.subspec 'GYDHTTPConnect' do |ss|
    ss.source_files = 'GYDHTTPConnect/Code/**/*'
    ss.dependency "GYDFoundation/GYDFoundation"
    ss.pod_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS'=>'GYD_FOUNDATION_USED_HTTPCONNECT=1'}
  end
  #json-model互转
  s.subspec 'GYDJSONObject' do |ss|
    ss.source_files = 'GYDJSONObject/Code/**/*'
    ss.dependency "GYDFoundation/GYDFoundation"
    ss.pod_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS'=>'GYD_FOUNDATION_USED_JSON_OBJECT=1'}
  end
  #特殊情况
  s.subspec 'GYDJSONObjectNonatomic' do |ss|
    ss.dependency "GYDFoundation/GYDJSONObject"
    ss.pod_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS'=>'GYD_JSON_OBJECT_ATOMIC=0'}
  end
  s.subspec 'Development' do |ss|
    ss.dependency "GYDFoundation/GYDFoundation"
    ss.pod_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS'=>'GYD_FOUNDATION_DEVELOPMENT=1'}
  end
  
  #单元测试
  s.test_spec 'Tests' do |ss|
    ss.source_files = 'GYDFoundation/Tests/Placeholder/**/*'
    ss.test_spec 'GYDFoundation' do |test|
      test.ios.source_files = ['GYDFoundation/Tests/Base/**/*','GYDFoundation/Tests/iOS/**/*']
      test.osx.source_files = ['GYDFoundation/Tests/Base/**/*','GYDFoundation/Tests/MacOS/**/*']
    end
    ss.test_spec 'GYDDatabase' do |test|
      test.source_files = 'GYDDatabase/Tests/**/*'
    end
    ss.test_spec 'GYDHTTPConnect' do |test|
      test.source_files = 'GYDHTTPConnect/Tests/**/*'
    end
    ss.test_spec 'GYDJSONObject' do |test|
      test.source_files = 'GYDJSONObject/Tests/**/*'
    end
  end
  
  #示例
  s.subspec 'Demo' do |ss|
    ss.subspec 'GYDFoundation' do |demo|
      demo.dependency 'GYDFoundation/GYDFoundation'
      demo.ios.source_files = ['GYDFoundation/Demo/Base/**/*','GYDFoundation/Demo/iOS/**/*']
      demo.osx.source_files = ['GYDFoundation/Demo/Base/**/*','GYDFoundation/Demo/MacOS/**/*']
    end
    ss.subspec 'GYDDatabase' do |demo|
      demo.dependency 'GYDFoundation/GYDDatabase'
      demo.source_files = 'GYDDatabase/Demo/**/*'
    end
    ss.subspec 'GYDHTTPConnect' do |demo|
      demo.dependency 'GYDFoundation/GYDHTTPConnect'
      demo.source_files = 'GYDHTTPConnect/Demo/**/*'
    end
    ss.subspec 'GYDJSONObject' do |demo|
      demo.dependency 'GYDFoundation/GYDJSONObject'
      demo.source_files = 'GYDJSONObject/Demo/**/*'
    end
  end
end
