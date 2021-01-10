platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

target 'HYWork' do
    
pod 'AlicloudPush','~> 1.9.2'

pod 'Masonry'

pod 'IQKeyboardManager'

pod 'TZImagePickerController'
#图片浏览器替换 2021.1.8
#pod 'XLPhotoBrowser+CoderXL'
pod 'YBImageBrowser'

pod 'DGActivityIndicatorView', '~> 2.1.1'
pod 'MJExtension', '~> 3.0.13'

pod 'SSZipArchive'

#loading
pod 'SVProgressHUD'

# 高德
pod 'AMap3DMap' #3D地图SDK
pod 'AMapSearch' #地图SDK搜索功能
pod 'AMapLocation' #定位SDK $pod 'AMapLocation' 命令还会引入基础 SDK ，涉及到提交AppStore成功与否   AMapFoundation (1.5.5)

# 主模块(必须)
pod 'mob_sharesdk'

# UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
pod 'mob_sharesdk/ShareSDKUI'

# 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'  #（微信sdk不带支付的命令）

# 扩展模块（在调用可以弹出我们UI分享方法的时候是必需的）
pod 'mob_sharesdk/ShareSDKExtension'

#无线轮播 2021.1.8
pod 'SDCycleScrollView','>= 1.82'

end
