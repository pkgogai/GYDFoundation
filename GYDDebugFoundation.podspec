
Pod::Spec.new do |s|
  s.name             = 'GYDDebugFoundation'
  s.version          = '1.0.4'
  s.summary          = 'GYDDebugFoundation'

  s.description      = <<-DESC
平时积累的一些代码，
也许有用，也许没用。
                       DESC

  s.homepage         = 'https://gitee.com/pkgogai'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pkgogai' => 'pkgogai@163.com' }
  s.source           = { :git => 'https://github.com/pkgogai/GYDFoundation.git', :tag => s.version.to_s }
  s.platform = :ios, '8.0'
  s.requires_arc = true
  s.framework = 'UIKit'

  s.dependency "GYDFoundation"
  s.source_files = 'GYDDebugFoundation/Code/*'
  
  #接口协议
  s.subspec 'Interface' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/Interface/**/*'
  end
  
  #附加调试信息
  s.subspec 'GYDDebugInfo' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDDebugInfo/**/*'
  end
  
  #调试窗口
  s.subspec 'GYDDebugView' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDDebugView/**/*'
  end
  
  #日志窗口
  s.subspec 'GYDLogUI' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDLogUI/**/*'
  end
  
  #计时
  s.subspec 'GYDTimeKeeper' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDTimeKeeper/**/*'
  end
  
  #数图形
  s.subspec 'GYDTreeView' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDTreeView/**/*'
  end
  
  #红点数展示
  s.subspec 'GYDUnreadCount' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDUnreadCount/**/*'
  end
  
  #视图层级展示
  s.subspec 'GYDViewHierarchy' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDViewHierarchy/**/*'
  end
  
  #视图提示
  s.subspec 'GYDViewTips' do |ss|
    ss.source_files = 'GYDDebugFoundation/Code/GYDViewTips/**/*'
  end
  
end
