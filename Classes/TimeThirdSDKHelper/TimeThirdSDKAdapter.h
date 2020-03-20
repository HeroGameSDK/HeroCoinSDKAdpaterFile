//
//  TimeThirdSDKAdapter.h
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TimeTwitterSDKAdapter.h"
#import "TimeLineSDKAdapter.h"
#import "TimeFBSDKAdapter.h"
#import "TimeThirdSDKLoginResult.h"
#import "TimeSharingObject.h"

@interface TimeThirdSDKAdapter : NSObject

/// 是否存在Facebook登录SDK
@property (nonatomic, assign) BOOL existedFBLoginSDK;
/// 是否存在Facebook分享SDK
@property (nonatomic, assign) BOOL existedFBSharingSDK;
/// 是否存在TwitterSDK
@property (nonatomic, assign) BOOL existedTwitterSDK;
/// 是否存在LineSDK
@property (nonatomic, assign) BOOL existedLineSDK;

/// 单例
+ (instancetype)shared;

/// 注册Twitter
- (void)registerTwitterWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options SDKType:(TimeThirdSDkType)SDKType;

/// 登录
/// @param SDKType 登录方式
/// @param fromViewController 来自哪个ViewController
/// @param callback 回调
- (void)loginWithSDKType:(TimeThirdSDkType)SDKType fromViewController:(UIViewController *)fromViewController callback:(TimeThirdSDKLoginCallback)callback;

/// 分享
/// @param platformType 分享平台
/// @param fromViewController 来自哪个viewController
/// @param sharingType 分享类型
/// @param sharingObj 分型内容
/// @param completion 完成回调
- (void)shareWithPlatformType:(TimeSharingPlatformType)platformType
               fromController:(UIViewController *)fromViewController
                  sharingType:(TimeSharingType)sharingType
                   sharingObj:(TimeSharingObject *)sharingObj
                   completion:(TimeThirdSDKSharingCallback)completion;
@end

