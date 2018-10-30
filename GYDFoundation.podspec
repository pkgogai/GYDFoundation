
Pod::Spec.new do |spec|
  spec.name             = 'GYDFoundation'
  spec.version          = '0.0.1'
  spec.summary          = 'GYDFoundation'

  spec.description      = <<-DESC
自己积累的一些代码
                       DESC

  spec.homepage         = 'https://github.com/pkgogai/GYDFoundation'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'pkgogai' => 'pkgogai@163.com' }
  spec.source           = { :git => 'https://github.com/pkgogai/GYDFoundation.git', :tag => spec.version.to_s }

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.8'

  spec.ios.source_files = 'GYDFoundation/**/*'
  spec.osx.source_files = 'GYDFoundation/GYDFoundation/**/*'
  spec.ios.requires_arc = true
  spec.ios.framework = 'UIKit'

end
