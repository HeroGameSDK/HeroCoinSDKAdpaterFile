//
//  TimeFBSDKAdapter.h
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "TimeHelper.h"
#import "TimeSharingObject.h"

/// 引入Facebook登录SDK
#define FBSDKLoginModule __has_include(<FBSDKLoginKit/FBSDKLoginKit.h>)
#if FBSDKLoginModule
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#endif

/// 引入Facebook分享SDK
#define FBSDKShareModule __has_include(<FBSDKShareKit/FBSDKShareKit.h>)
#if FBSDKShareModule
#import <FBSDKShareKit/FBSDKShareKit.h>
#endif

#define FBAdapter [TimeFBSDKAdapter shared]

@interface TimeFBSDKAdapter : NSObject

/// 单例
+ (instancetype)shared;

/// 是否存在登录SDK
@property (nonatomic, assign) BOOL existedLoginSDK;

/// 是否存在分享SDK
@property (nonatomic, assign) BOOL existedSharingSDK;

/// 登录
- (void)loginWithFromViewController:(UIViewController *)fromViewController callback:(TimeThirdSDKLoginCallback)callback;

/// 分享到Facebook
- (void)shareWithFromController:(UIViewController *)fromViewController
                    sharingType:(TimeSharingType)sharingType
                     sharingObj:(TimeSharingObject *)sharingObj
                     completion:(TimeThirdSDKSharingCallback)completion;

/// 分享到Messenger
- (void)shareToFacebookMessenger:(TimeSharingType)shareType
                     shareObject:(TimeSharingObject *)sharingObj
                      completion:(TimeThirdSDKSharingCallback)completion;
@end

