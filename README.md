# GYDFoundation

#### 项目介绍
个人的iOS私有库

#### 目录结构

1. 外层结构
	- GYDFoundation：基础代码
	- GYDDatabase：数据库，依赖FMDB
	- GYDHTTPConnect：网络请求，
	- GYDJSONObject：JSON-Model互转
	- iOSExample：iOS示例工程
	- MacExample：Mac示例工程
	- GYDFoundation.podspec：pod配置文件

2. 内层结构
	- Code: 功能代码
	- Resources: 图片等资源文件
	- Test: 单元测试代码
	- Demo: 示例代码

#### 安装教程
使用POD安装，Podfile配置方法如下：

1. 安装默认功能：
	默认功能包括：GYDFoundation，GYDDatabase，GYDHTTPConnect，GYDJSONObject'
	
	```
	pod 'GYDFoundation'
	```
	
	现在还没向pod提交，可以直接指定git路径。
	
	```
	pod 'GYDFoundation',
	  :git => 'https://github.com/pkgogai/GYDFoundation.git',
	  :tag => '0.0.4'
	  #tag可以改成分支或节点
	  #:branch => 'master'
	  #:commit => 'f7cc204e2db82f8488229f09e073977d3db4abbd'
	```

2. 安装指定功能：
	如只想安装其中个别功能，可指定subspecs，如只需要GYDJSONObject，依赖的GYDFoundation也会同时被引入：
	
	```
	pod 'GYDFoundation',
	  :git => 'https://github.com/pkgogai/GYDFoundation.git',
	  :tag => '0.0.4',
	  :subspecs => ['GYDJSONObject']
	```
		
3. 安装单元测试：
	4个subspecs都有与其对应的单元测试代码，可按需添加对应的testspecs，虽然目前只是随便写写，但下辈子也许会完善的。
	
	```
	……前面省略……
	:testspecs => ['Tests/GYDFoundation','Tests/GYDDatabase','Tests/GYDHTTPConnect','Tests/GYDJSONObject']
	```
	
	为了可以手动点击单个测试用例，需要在工程Schemes编辑中，“Test”>“Info”>“+”，选择“GYDFoundation-Unit-Tests”完成添加。
	
4. 安装Demo：
	这里还有演示如何使用的Demo。单元测试正式项目也会依赖，而Demo不同，是单独用来演示用的，所以没必要拆分，直接依赖所有功能。
	
	```
	……前面省略……
	:subspecs => ['Demo']
	```

5. 本人在开发时使用本地相对路径，Demo，Tests全都要

	```
	pod 'GYDFoundation', 
    :path => '../../GYDFoundation',
    :subspecs => ['Demo'],
    :testspecs => ['Tests/GYDFoundation','Tests/GYDDatabase','Tests/GYDHTTPConnect','Tests/GYDJSONObject',]
	```

#### 使用说明

1. 引用头文件：

	聚合类头文件：GYDFoundation.h，GYDUIKit.h
	GYDFoundation.h会将所选功能的头文件都包含进去，只有UIKit相关除外，在开发非UI类时建议使用这个。
	GYDUIKit.h在GYDFoundation.h基础上包含了其余UIKit相关的头文件，在开发UI类时建议使用这个。
	也可根据需要只引用具体某个头文件，但还是建议上面2选1。
	我习惯在User Header Search Paths里加一个值${HEADER_SEARCH_PATHS}，这样所有文件都可使用双引号引用，风格统一，不同功能库间可以直接移动文件。
	
	```
	#import "GYDFoundation.h"
	```
	
2. 其它的以后再说吧

