//
//  CCPowerHelper.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/12.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPowerHelper.h"

//#import <objc/objc-runtime.h>
#import <objc/runtime.h>

// 蜂窝数据
#import <CoreTelephony/CTCellularData.h>

/// 音视频(相机 / 麦克风)
#import <AVFoundation/AVFoundation.h>

/// 相册
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

/// 定位
#import <CoreLocation/CoreLocation.h>

/// 通讯录
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

/// 日历 / 提醒事项
#import <EventKit/EventKit.h>


@interface _CCPowerDelegate : NSObject <CLLocationManagerDelegate>

+ (instancetype)delegateWithAuthorized:(CCPowerDidAuthorized)authorizedHandle denied:(CCPowerDidDenied)deniedHandle notDetermined:(CCPowerDidNotDetermined)notDeterminedHandle;

/** 授权回调 */
@property (nullable, nonatomic, copy) CCPowerDidAuthorized authorizedHandle;
/** 拒绝回调 */
@property (nullable, nonatomic, copy) CCPowerDidDenied deniedHandle;
/** 未授权回调 */
@property (nullable, nonatomic, copy) CCPowerDidNotDetermined notDeterminedHandle;

@end

@implementation _CCPowerDelegate

#pragma mark - Reload
+ (instancetype)delegateWithAuthorized:(CCPowerDidAuthorized)authorizedHandle denied:(CCPowerDidDenied)deniedHandle notDetermined:(CCPowerDidNotDetermined)notDeterminedHandle {
    _CCPowerDelegate *delegate = [self new];
    delegate.authorizedHandle = authorizedHandle ? authorizedHandle : ^{};
    delegate.deniedHandle = deniedHandle ? deniedHandle : ^{};
    delegate.notDeterminedHandle = notDeterminedHandle ? notDeterminedHandle : ^ BOOL{ return YES; };
    return delegate;
}


#pragma mark - Protocol
/// CLLocationManagerDelegate
/**
 当定位权限改变时调用

 @param manager 位置对象
 @param status 状态
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
//        case kCLAuthorizationStatusAuthorized:        /// iOS8 之前字段, iOS8之后更新为下面字段
        case kCLAuthorizationStatusAuthorizedAlways:    /// iOS8 之后: 授权
        case kCLAuthorizationStatusAuthorizedWhenInUse: /// iOS8 之后: 使用时授权
            _authorizedHandle();
            break;
        case kCLAuthorizationStatusRestricted:          /// 受限制
        case kCLAuthorizationStatusDenied:              /// 拒绝
            _deniedHandle();
            break;
        case kCLAuthorizationStatusNotDetermined:       /// 未决定
            if (_notDeterminedHandle()) {
                _authorizedHandle();
            }
            break;
        default:
            break;
    }
}


@end


static CTCellularData *cellular;
static CLLocationManager *locationManager;

@implementation CCPowerHelper

#pragma mark - Initialize
+ (void)initialize {
    [super initialize];
    
    /// 网络 - 蜂窝数据
    if (!k_iOS9_BEFORE) {
        // 创建蜂窝数据对象 iOS9以后可用
        cellular = [CTCellularData new];
        // 添加当蜂窝数据限制变化时的回调
        [cellular setCellularDataRestrictionDidUpdateNotifier:^(CTCellularDataRestrictedState state) {
            switch (state) {
                case kCTCellularDataRestrictedStateUnknown:     // 未知
                    
                    break;
                case kCTCellularDataRestricted:                 // 限制
                    
                    break;
                case kCTCellularDataNotRestricted:              // 无限制
                    
                    break;
                default:
                    break;
            }
        }];
    }
}


#pragma mark - Private
/**
 权限_返回蜂窝数据是否有限制, iOS9及以上可用
 */
+ (BOOL)powerForNetworkIsRestricted {
    return cellular.restrictedState == kCTCellularDataRestricted;
}

/**
 对指定类型资源的权限处理, 请在对应的回调中做好处理, 最好不要使用直接返回的BOOL值做判断
 
 @param option 指定所请求的权限
 @param authorizedHandle 请求类型权限为授权的处理
 @param deniedHandle 请求类型权限为拒绝的处理
 @param notDeterminedHandle 请求类型权限为未决定的处理
 @return 返回最终授权的结果, 以便于后面的操作
 */
+ (void)powerForOption:(CCPowerOption)option authorized:(CCPowerDidAuthorized)authorizedHandle denied:(CCPowerDidDenied)deniedHandle notDetermined:(CCPowerDidNotDetermined)notDeterminedHandle {
    _CCPowerDelegate *delegate = [_CCPowerDelegate delegateWithAuthorized:authorizedHandle denied:deniedHandle notDetermined:notDeterminedHandle];
    
    switch (option) {
        case CCPowerOptionPhotoLib:     // 相册权限
            [self powerForPhotoLibraryWithDelegate:delegate];
            break;
        case CCPowerOptionCamera:       // 相机权限
            [self powerForMediaType:AVMediaTypeVideo delegate:delegate];
            break;
        case CCPowerOptionMicrophone:   // 麦克风权限
            [self powerForMediaType:AVMediaTypeAudio delegate:delegate];
            break;
        case CCPowerOptionLocationAlway:     // 定位权限
            [self powerForLocationSelector:@selector(requestAlwaysAuthorization) delegate:delegate];
            break;
        case CCPowerOptionLocationWhenUse:     // 定位权限
            [self powerForLocationSelector:@selector(requestWhenInUseAuthorization) delegate:delegate];
            break;
        case CCPowerOptionNotification: // 通知权限
            [self powerForNotification];
            break;
        case CCPowerOptionConacts:      // 联系人权限
            [self powerForContactsWithDelegate:delegate];
            break;
        case CCPowerOptionBluetooth:    // 蓝牙权限
            NSCAssert(NO, @"先看看Github上蓝牙第三方库的使用");
            break;
        case CCPowerOptionCalendar:     // 日历权限
            [self powerForEKType:EKEntityTypeEvent delegate:delegate];
            break;
        case CCPowerOptionReminder:     // 备忘录权限
            [self powerForEKType:EKEntityTypeReminder delegate:delegate];
            break;
        case CCPowerOptionSiri:         // Siri权限
            NSCAssert(NO, @"看看Siri的使用");
            break;
        default:
            NSCAssert(NO, @"你搞事情哈!!!");
            break;
    }
}

/**
 权限_请求相册
 
 @param authorizedHandle    授权的回调
 @param deniedHandle        拒绝的回调
 @param notDeterminedHandle 未决定的回调
 @return 返回结果
 */
+ (void)powerForPhotoLibraryWithDelegate:(_CCPowerDelegate *)delegate {
    if (k_iOS8_BEFORE) {
        /// iOS.8以前
        /// iOS.6 - iOS.9
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        switch (status) {
            case ALAuthorizationStatusDenied:           // 拒绝
            case ALAuthorizationStatusRestricted:       // 受限制
                delegate.deniedHandle();
                break;
            case ALAuthorizationStatusAuthorized:       // 授权
            case ALAuthorizationStatusNotDetermined:    // 未决定
                if (delegate.notDeterminedHandle()) {
                    delegate.authorizedHandle();
                }
                break;
            default:
                break;
        }
    } else {
        /// iOS.8及以后
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        switch (photoAuthorStatus) {
            case PHAuthorizationStatusAuthorized:       // 授权
                delegate.authorizedHandle();
                break;
            case PHAuthorizationStatusDenied:           // 拒绝
            case PHAuthorizationStatusRestricted:       // 受限制
                delegate.deniedHandle();
                break;
            case PHAuthorizationStatusNotDetermined: {   // 未决定
                if (!delegate.notDeterminedHandle()) break;
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    switch (status) {
                        case PHAuthorizationStatusAuthorized:       // 授权
                            delegate.authorizedHandle();
                            break;
                        case PHAuthorizationStatusDenied:           // 拒绝
                        case PHAuthorizationStatusRestricted:       // 受限制
                            delegate.deniedHandle();
                            break;
                        case PHAuthorizationStatusNotDetermined:    // 未决定
                        default:
                            break;
                    }
                }];
                break;
            }
            default:
                break;
        }
    }
}

/**
 权限_请求相机 / 麦克风权限
 
 @param type @"AVMediaTypeVideo" or @"AVMediaTypeAudio"
 @param authorizedHandle    授权的回调
 @param deniedHandle        拒绝的回调
 @param notDeterminedHandle 未决定的回调
 */
+ (void)powerForMediaType:(NSString *)type delegate:(_CCPowerDelegate *)delegate {
    
    if (k_iOS7_BEFORE) return ;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:type];

    switch (authStatus) {
        case AVAuthorizationStatusAuthorized:       // 授权
            delegate.authorizedHandle();
            break;
        case AVAuthorizationStatusDenied:           // 拒绝
        case AVAuthorizationStatusRestricted:       // 受限制
            delegate.deniedHandle();
            break;
        case AVAuthorizationStatusNotDetermined: {   // 未决定
            if (!delegate.notDeterminedHandle()) break;
            [AVCaptureDevice requestAccessForMediaType:type completionHandler:^(BOOL granted) {
                if (granted) {
                    delegate.authorizedHandle();
                } else {
                    delegate.deniedHandle();
                }
            }];
            break;
        }
        default:
            break;
    }
}

static int _CCLocationDelegateKey;
+ (void)powerForLocationSelector:(SEL)requestSelector delegate:(_CCPowerDelegate *)delegate {
    // 判断系统定位服务是否开启  (设置 -> 隐私 -> 定位服务)
    BOOL locationEnabled = [CLLocationManager locationServicesEnabled];
    
    if (!locationEnabled) {
        delegate.deniedHandle();
        return;
    }
    
    if (!locationManager) {
        locationManager = [CLLocationManager new];
    }
    /// 为locationManager对象添加数据, 指向该代理, 以防止代理对象销毁
    objc_setAssociatedObject(locationManager, &_CCLocationDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    locationManager.delegate = delegate;
    
    /// 调用授权方法, 在代理回调中处理
    if ([locationManager respondsToSelector:requestSelector]) {
        [locationManager performSelector:requestSelector];
    }
}

+ (void)powerForNotification {
    /**
     * 一般使用了极光等第三方SDK, 内部就会执行下面代码, 所以可以按照情况调用
     */
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    /**
     * 可添加的参数 UIUserNotificationCategory
     * 此参数中可以定义对应的 identifier , 此对象中可以定义 key = value 存放对应的响应
     * 更详细的再Baidu吧
     */
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
}

+ (void)powerForContactsWithDelegate:(_CCPowerDelegate *)delegate {
    if (k_iOS9_BEFORE) {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        switch (status) {
            case kABAuthorizationStatusAuthorized:      // 授权
                delegate.authorizedHandle();
                break;
            case kABAuthorizationStatusDenied:          // 拒绝
            case kABAuthorizationStatusRestricted:      // 受限制
                delegate.deniedHandle();
                break;
            case kABAuthorizationStatusNotDetermined: { // 未决定
                if (!delegate.notDeterminedHandle()) break;
                
                ABAddressBookRef bookRef = ABAddressBookCreate();
                
                ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
                    if (granted) {
                        delegate.authorizedHandle();
                    } else {
                        delegate.deniedHandle();
                    }
                    CFRelease(bookRef);
                });
                break;
            }
            default:
                break;
        }

    } else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:       // 授权
                delegate.authorizedHandle();
                break;
            case CNAuthorizationStatusDenied:           // 拒绝
            case CNAuthorizationStatusRestricted:       // 受限制
                delegate.deniedHandle();
                break;
            case CNAuthorizationStatusNotDetermined: {  // 未决定
                if (!delegate.notDeterminedHandle()) break;
                
                /// 已经测试, 即使这里是局部变量也可以完成请求权限
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        delegate.authorizedHandle();
                    }else{
                        delegate.deniedHandle();
                    }
                }];
                break;
            }
            default:
                break;
        }
    }
}

+ (void)powerForEKType:(EKEntityType)type delegate:(_CCPowerDelegate *)delegate {
    
    /// iOS.6以后
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
    switch (status) {
        case EKAuthorizationStatusAuthorized:       // 授权
            delegate.authorizedHandle();
            break;
        case EKAuthorizationStatusDenied:           // 拒绝
        case EKAuthorizationStatusRestricted:       // 受限制
            delegate.deniedHandle();
            break;
        case EKAuthorizationStatusNotDetermined: {  // 未决定
            if (!delegate.notDeterminedHandle()) break;
            
            /// 已经测试, 即使这里是局部变量也可以完成请求权限
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    delegate.authorizedHandle();
                }else{
                    delegate.deniedHandle();
                }
            }];
            break;
        }
        default:
            break;
    }
}


@end
