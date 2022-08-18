
Pod::Spec.new do |s|
  s.name             = 'GYDFoundationDemo'
  s.version          = '1.0.4'
  s.summary          = 'GYDFoundation的Demo'

  s.description      = <<-DESC
平时积累的一些代码，
也许有用，也许没用。
                       DESC

  s.homepage         = 'https://github.com/pkgogai/GYDFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pkgogai' => 'pkgogai@163.com' }
  s.source           = { :git => 'https://github.com/pkgogai/GYDFoundation.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.13'
  s.ios.requires_arc = true
  s.ios.framework = 'UIKit'

  s.dependency 'GYDFoundation'
  s.dependency 'GYDDebugFoundation'
  
#  s.default_subspec = ['GYDFoundation', 'GYDDatabase', 'GYDHTTPConnect', 'GYDJSONObject', 'GYDModuleInterface', 'GYDDebugViewHierarchyDemo', 'GYDDebugViewTipsDemo', 'GYDHorizontalTreeViewDemo', 'GYDTimeKeeperDemo']
  s.ios.source_files = 'Demo/*'
  #示例
  s.subspec 'GYDFoundation' do |demo|
    demo.ios.source_files = ['Demo/GYDFoundation/Base/**/*','Demo/GYDFoundation/iOS/**/*']
    demo.osx.source_files = ['Demo/GYDFoundation/Base/**/*','Demo/GYDFoundation/MacOS/**/*']
  end
  s.subspec 'GYDDatabase' do |demo|
    demo.source_files = 'Demo/GYDDatabase/**/*'
  end
  s.subspec 'GYDHTTPConnect' do |demo|
    demo.source_files = 'Demo/GYDHTTPConnect/**/*'
  end
  s.subspec 'GYDJSONObject' do |demo|
    demo.source_files = 'Demo/GYDJSONObject/**/*'
  end
  s.subspec 'GYDModuleInterface' do |demo|
    demo.ios.source_files = 'Demo/GYDModuleInterface/**/*'
  end
  s.subspec 'GYDDebugViewHierarchyDemo' do |demo|
    demo.ios.source_files = 'GYDDebugFoundation/Demo/GYDDebugViewHierarchyDemo/**/*'
  end
  s.subspec 'GYDDebugViewTipsDemo' do |demo|
    demo.ios.source_files = 'GYDDebugFoundation/Demo/GYDDebugViewTipsDemo/**/*'
  end
  s.subspec 'GYDHorizontalTreeViewDemo' do |demo|
    demo.ios.source_files = 'GYDDebugFoundation/Demo/GYDHorizontalTreeViewDemo/**/*'
  end
  s.subspec 'GYDTimeKeeperDemo' do |demo|
    demo.source_files = 'GYDDebugFoundation/Demo/GYDTimeKeeperDemo/**/*'
  end
  s.subspec 'GYDShellTools' do |demo|
    demo.osx.source_files = 'Demo/GYDShellTools/**/*'
  end
  
end
