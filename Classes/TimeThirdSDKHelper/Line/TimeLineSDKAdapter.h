//
//  TimeLineSDKAdapter.h
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeHelper.h"
#import "TimeSharingObject.h"

#define LineSDKModule __has_include(<LineSDK/LineSDKLogin.h>)
#if LineSDKModule
@import LineSDK;
#endif

#define LineAdapter [TimeLineSDKAdapter shared]

@interface TimeLineSDKAdapter : NSObject

/// 单例
+ (instancetype)shared;

/// 是否存在SDK
@property (nonatomic, assign) BOOL existedSDK;

- (BOOL)handleOpenURL:(NSURL *)url;

/// 登录
- (void)loginWithCallback:(TimeThirdSDKLoginCallback)callback;

/// 分享
- (void)shareToLine:(TimeSharingType)shareType
        shareObject:(TimeSharingObject *)shareObj
         completion:(TimeThirdSDKSharingCallback)completion;

@end

