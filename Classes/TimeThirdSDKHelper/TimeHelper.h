//
//  TimeLogHelper.h
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HeroCoinSDK/HeroCoinSDK.h>
#import "TimeThirdSDKLoginResult.h"

/// 第三方SDK类型，与SDK内部ThirdSDkType保持一致
typedef NS_ENUM(NSInteger, TimeThirdSDkType) {
    ///  Facebook 登录
    TimeThirdSDkTypeFBLogin,
    /// Facebook 分享
    TimeThirdSDkTypeFBSharing,
    /// Twitter
    TimeThirdSDkTypeTwitter,
    /// Line
    TimeThirdSDkTypeLine
};

/// 第三方分享平台类型, 对应的值与SDK内部 TimeSocialPlatformType 保持一致
typedef NS_ENUM(NSInteger, TimeSharingPlatformType) {
    TimeSharePlatformTypeFacebook = 16,
    TimeSharePlatformTypeTwitter = 17,
    TimeSharePlatformTypeLine = 21,
    TimeSharePlatformTypeFaceBookMessenger = 34,
};

/// 分享类类型，跟SDK内部TimeSocialShareType是一一对应的
typedef NS_ENUM(NSUInteger, TimeSharingType) {
    ///纯文本                            //可支持分享的平台
    TimeSharingType_Text,           //Twitter,
    ///本地图片
    TimeSharingType_Image,          //Facebook, Messenger, Twitter
    ///Https网络图片
    TimeSharingType_Image_Url,      //Facebook, Messenger, Twitter
    ///文本+图片
    TimeSharingType_TextAndImage,   //Twitter
    ///网页链接
    TimeSharingType_Web_Link,       //Facebook, Messenger, Twitter
    ///网络视频url
    TimeSharingType_Video_Link,     //Twitter
    ///本地视频
    TimeSharingType_Video,          //Facebook
};

/// 第三方登录回调block
typedef void(^TimeThirdSDKLoginCallback)(TimeThirdSDKLoginResult *result);
/// 第三方分享回调block
typedef void (^TimeThirdSDKSharingCallback)(TimeSharingPlatformType platformType, NSString * _Nullable result, NSError * _Nullable error);

/// 打印Log
static inline void TimeLog(NSString *message) {
    if ([TimeSDKLogSystem sharedInstance].isNeedOpenLog) {
        NSLog(@"%@", message);
    }
}

/// 是否是NSNull类型
static inline BOOL IS_NULL(NSString *string) {
    return (!string || [string isKindOfClass:[NSNull class]]);
}

/// 是否是空串
static inline BOOL IS_EMPTY_STRING(NSString *string) {
    return (IS_NULL(string) || [string isEqual:@""] || [string isEqual:@"(null)"]);
}

@interface TimeHelper : NSObject

@end

