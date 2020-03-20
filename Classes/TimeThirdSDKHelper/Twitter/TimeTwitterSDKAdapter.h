//
//  TimeTwitterSDKAdapter.h
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TimeSharingObject.h"
#import "TimeHelper.h"

#define TwitterSDKModule __has_include(<TwitterKit/TWTRKit.h>)
#if TwitterSDKModule
@import TwitterKit;
#endif

#define TwitterAdapter [TimeTwitterSDKAdapter shared]

@interface TimeTwitterSDKAdapter : NSObject

/// 单例
+ (instancetype)shared;

/// 是否存在SDK
@property (nonatomic, assign) BOOL existedSDK;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options;

/// 注册Twitter
- (void)startWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

/// 登录
- (void)loginWithCallback:(TimeThirdSDKLoginCallback)callback;

/// 分享
- (void)shareWithFromController:(UIViewController *)fromViewController
                    sharingType:(TimeSharingType)sharingType
                     sharingObj:(TimeSharingObject *)sharingObj
                     completion:(TimeThirdSDKSharingCallback)completion;

@end

