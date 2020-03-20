//
//  TimeThirdSDKAdapter.m
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import "TimeThirdSDKAdapter.h"
#import "TimeHelper.h"

@implementation TimeThirdSDKAdapter

+ (instancetype)shared {
    static TimeThirdSDKAdapter *_timeThirdSDKAdapter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timeThirdSDKAdapter = [[TimeThirdSDKAdapter alloc] init];
        [_timeThirdSDKAdapter initData];
    });
    return _timeThirdSDKAdapter;
}

- (void)initData {
    _existedFBLoginSDK = FBAdapter.existedLoginSDK;
    _existedFBSharingSDK = FBAdapter.existedSharingSDK;
    _existedTwitterSDK = TwitterAdapter.existedSDK;
    _existedLineSDK = LineAdapter.existedSDK;
}

- (void)registerTwitterWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    [TwitterAdapter startWithConsumerKey:consumerKey consumerSecret:consumerSecret];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options SDKType:(TimeThirdSDkType)SDKType
{
    if (SDKType == TimeThirdSDkTypeLine) {
        return [LineAdapter handleOpenURL:url];
    } else if (SDKType == TimeThirdSDkTypeTwitter) {
        return [TwitterAdapter application:application openURL:url options:options];
    }
    
    return false;
}

/// 登录
/// @param SDKType 登录方式
/// @param fromViewController 来自哪个ViewController
/// @param callback 回调
- (void)loginWithSDKType:(TimeThirdSDkType)SDKType fromViewController:(UIViewController *)fromViewController callback:(TimeThirdSDKLoginCallback)callback
{
    if (SDKType == TimeThirdSDkTypeFBLogin) {
        if (self.existedFBLoginSDK) {
            [FBAdapter loginWithFromViewController:fromViewController callback:callback];
        } else {
            TimeLog(@"没有导入Facebook登录SDK");
        }
    } else if (SDKType == TimeThirdSDkTypeTwitter) {
        if (self.existedTwitterSDK) {
            [TwitterAdapter loginWithCallback:callback];
        } else {
            TimeLog(@"没有导入Twitter SDK");
        }
    } else if (SDKType == TimeThirdSDkTypeLine) {
        if (self.existedLineSDK) {
            [LineAdapter loginWithCallback:callback];
        } else {
            TimeLog(@"没有导入Line SDK");
        }
    } else {
        TimeLog(@"不支持的登录方式");
    }
}

/// 分享
- (void)shareWithPlatformType:(TimeSharingPlatformType)platformType
               fromController:(UIViewController *)fromViewController
                  sharingType:(TimeSharingType)sharingType
                   sharingObj:(TimeSharingObject *)sharingObj
                   completion:(TimeThirdSDKSharingCallback)completion
{
    switch (platformType) {
        case TimeSharePlatformTypeFacebook: // 分享到Facebook
        case TimeSharePlatformTypeFaceBookMessenger: // 分享到Messenger
        {
            if (self.existedFBSharingSDK) {
                if (platformType == TimeSharePlatformTypeFacebook) { // Facebook
                    [FBAdapter shareWithFromController:fromViewController
                                           sharingType:sharingType
                                            sharingObj:sharingObj
                                            completion:completion];
                }
//                else if (platformType == TimeSharePlatformTypeFaceBookMessenger) { // Messenger
//                    [FBAdapter shareToFacebookMessenger:sharingType
//                                            shareObject:sharingObj
//                                             completion:completion];
//                }
            } else {
                TimeLog(@"没有导入Facebookf分享SDK");
            }
        }
            break;
            
        case TimeSharePlatformTypeTwitter: // 分享到Twitter
        {
            if (self.existedTwitterSDK) {
                [TwitterAdapter shareWithFromController:fromViewController
                                            sharingType:sharingType
                                             sharingObj:sharingObj
                                             completion:completion];
            } else {
                TimeLog(@"没有导入Twitter SDK");
            }
        }
            break;
        case TimeSharePlatformTypeLine:  // 分享到Line
        {
            if (self.existedLineSDK) {
                [LineAdapter shareToLine:sharingType
                             shareObject:sharingObj
                              completion:completion];
            } else {
                TimeLog(@"没有导入Line SDK");
            }
        }
            break;
        default:
        {
            TimeLog(@"不支持的分享方式");
        }
            break;
    }
}
@end
