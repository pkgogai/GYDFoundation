
Pod::Spec.new do |s|
  s.name             = 'GYDFoundation'
  s.version          = '0.0.1'
  s.summary          = 'GYDFoundation'

  s.description      = <<-DESC
自己积累的一些代码
                       DESC

  s.homepage         = 'https://github.com/pkgogai/GYDFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pkgogai' => 'pkgogai@163.com' }
  s.source           = { :git => 'https://github.com/pkgogai/GYDFoundation.git', :tag => s.version.to_s }

  s.platform     = :ios, "7.0"

  s.source_files = 'GYDFoundation/**/*'
  s.requires_arc = true
  s.frameworks = 'UIKit'

end
