//
//  CCPowerHelper.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/12.
//  Copyright © 2017年 CC. All rights reserved.
//

/**
 权限
 info.plist 中添加的字段
    <key>NSBluetoothPeripheralUsageDescription</key>
	<string>需要您的同意, 才能访问蓝牙</string>
	<key>NSCalendarsUsageDescription</key>
	<string>需要您的同意, 才能访问日历</string>
	<key>NSCameraUsageDescription</key>
	<string>需要您的同意, 才能访问相机</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>需要您的同意, 才能访问相册</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>需要您的同意, 才能访问麦克风</string>
	<key>NSContactsUsageDescription</key>
	<string>需要您的同意, 才能访问联系人</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>需要您的同意, 才能访问定位</string>
	<key>NSLocationUsageDescription</key>
	<string>需要您的同意, 才能访问定位</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>需要您的同意, 才能访问定位</string>
	<key>NSMotionUsageDescription</key>
	<string>需要您的同意, 才能访问运动与健身</string>
	<key>NSRemindersUsageDescription</key>
	<string>需要您的同意, 才能访问提醒事项</string>
	<key>NSSiriUsageDescription</key>
	<string>需要您的同意, 才能访问Siri</string>
	<key>NSSpeechRecognitionUsageDescription</key>
	<string>需要您的同意, 才能访问语言识别</string>
	<key>NSHealthShareUsageDescription</key>
	<string>需要您的同意,才能访问健康分享</string>
	<key>NSHealthUpdateUsageDescription</key>
	<string>需要您的同意,才能访问健康更新</string>
	<key>NSAppleMusicUsageDescription</key>
	<string>需要您的同意,才能访问媒体资料库</string>
	<key>NSHomeKitUsageDescription</key>
	<string>需要您的同意, 才能访问</string>
	<key>kTCCServiceMediaLibrary</key>
	<string>需要您的同意, 才能访问</string>
	<key>NSVideoSubscriberAccountUsageDescription</key>
	<string>需要您的同意, 才能访问</string>
 
 蜂窝权限: 有限制, 无网络, 但是不崩溃     无限制, 在判断其他条件
 */



#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, CCPowerOption) {
//    CCPowerOptionNetwork,         // 网络权限       // 不可以使用
    CCPowerOptionPhotoLib,          // 相册权限
    CCPowerOptionCamera,            // 相机权限
    CCPowerOptionMicrophone,        // 麦克风权限
    CCPowerOptionLocationAlway,     // 定位权限
    CCPowerOptionLocationWhenUse,   // 定位权限
    CCPowerOptionNotification,      // 通知权限
    CCPowerOptionConacts,           // 联系人权限
    CCPowerOptionBluetooth,         // 蓝牙权限
    CCPowerOptionCalendar,          // 日历权限
    CCPowerOptionReminder,          // 提醒事项权限
    CCPowerOptionSiri               // Siri权限
};

#define k_iOS7_BEFORE (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0)
#define k_iOS8_BEFORE (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0)
#define k_iOS9_BEFORE (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_0)

typedef dispatch_block_t CCPowerDidAuthorized;
typedef dispatch_block_t CCPowerDidDenied;
typedef BOOL (^CCPowerDidNotDetermined)();

@interface CCPowerHelper : NSObject


/**
 权限_返回蜂窝数据是否有限制, iOS9及以上可用
 */
+ (BOOL)powerForNetworkIsRestricted NS_AVAILABLE_IOS(9_0);

/**
 对指定类型资源的权限处理, 请在对应的回调中做好处理, 最好不要使用直接返回的BOOL值做判断
 
 @param option 指定所请求的权限
 @param authorizedHandle 请求类型权限为授权的处理
 @param deniedHandle 请求类型权限为拒绝的处理
 @param notDeterminedHandle 请求类型权限为未决定的处理
 @return 返回最终授权的结果, 以便于后面的操作
 */
+ (void)powerForOption:(CCPowerOption)option authorized:(CCPowerDidAuthorized)authorizedHandle denied:(CCPowerDidDenied)deniedHandle notDetermined:(CCPowerDidNotDetermined)notDeterminedHandle;


@end
