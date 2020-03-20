//
//  TimeLineSDKAdapter.m
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import "TimeLineSDKAdapter.h"

#if LineSDKModule
@interface TimeLineSDKAdapter()<LineSDKLoginDelegate>
@end
#endif

@interface TimeLineSDKAdapter()
@property (nonatomic, copy) TimeThirdSDKLoginCallback loginCallback;
@end

@implementation TimeLineSDKAdapter

+ (instancetype)shared {
    static TimeLineSDKAdapter *_adapter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _adapter = [[TimeLineSDKAdapter alloc] init];
    });
    return _adapter;
}

- (BOOL)existedSDK {
    if (_existedSDK) {
        return _existedSDK;
    }
    
#if LineSDKModule
    _existedSDK = true;
#endif
    
    return _existedSDK;
}

#if LineSDKModule // ------- 用到LineSDK内部东西的部分 begin --------------

- (BOOL)handleOpenURL:(NSURL *)url {
    return [[LineSDKLogin sharedInstance] handleOpenURL:url];
}

- (void)loginWithCallback:(TimeThirdSDKLoginCallback)callback {
    self.loginCallback = callback;
    [LineSDKLogin sharedInstance].delegate = self;
    [[LineSDKLogin sharedInstance] startLoginWithPermissions:@[@"profile", @"friends", @"groups"]];
}

#pragma mark - LineSDKLoginDelegate

- (void)didLogin:(LineSDKLogin *)login credential:(LineSDKCredential *)credential profile:(LineSDKProfile *)profile error:(NSError *)error {
    
    TimeThirdSDKLoginResult *result = [[TimeThirdSDKLoginResult alloc] init];
    if (error) {
        result.error = error;
    } else {
        result.userId = profile.userID;
        result.accessToken = credential.accessToken.accessToken;
    }
    
    if (self.loginCallback) {
        self.loginCallback(result);
    }
    
    /// 用完后释放掉
    self.loginCallback = nil;
}

#endif  // ------- 用到LineSDK内部东西的部分 end --------------

#pragma mark - 分享
- (void)shareToLine:(TimeSharingType)shareType
        shareObject:(TimeSharingObject *)shareObj
         completion:(TimeThirdSDKSharingCallback)completion
{
    switch (shareType) {
        case TimeSocialShareType_Text:
            [self shareTextToLine:shareObj completion:completion];
            break;
        case TimeSocialShareType_Image:
            [self shareImageToLine:shareObj completion:completion];
            break;
        default:
            {
                NSString *errorMessage = @"Line 分享失败, 不支持的分享方式";
                TimeLog(errorMessage);
                if (completion) {
                    NSError *error = [[NSError alloc] initWithDomain:errorMessage code:-999 userInfo:nil];
                    completion(TimeSharePlatformTypeLine, errorMessage, error);
                }
            }
            break;
    }
}

- (void)shareTextToLine:(TimeSharingObject *)sharingObj
             completion:(TimeThirdSDKSharingCallback)completion
{
    NSString *contentType = @"text";
    NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",contentType, sharingObj.title];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:url];
        }
    } else {
        NSString *errorMessage = @"Line 分享失败, 没有安装Line App";
        TimeLog(errorMessage);
        if (completion) {
            NSError *error = [[NSError alloc] initWithDomain:errorMessage code:-999 userInfo:nil];
            completion(TimeSharePlatformTypeLine, errorMessage, error);
        }
    }
}

- (void)shareImageToLine:(TimeSharingObject *)sharingObj
              completion:(TimeThirdSDKSharingCallback)completion
{
    UIImage *image = nil;
    if ([sharingObj.shareImage isKindOfClass:[NSString class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:sharingObj.shareImage]];
        image = [UIImage imageWithData:data];
    } else if ([sharingObj.shareImage isKindOfClass:[NSData class]]) {
        image = [UIImage imageWithData:(NSData *)sharingObj.shareImage];
    } else if ([sharingObj.shareImage isKindOfClass:[UIImage class]]) {
        image = sharingObj.shareImage;
    }
    
    if (image == nil) {
        NSString *errorMessage = @"Line 分享失败, 分享图片为空";
        TimeLog(errorMessage);
        if (completion) {
            NSError *error = [[NSError alloc] initWithDomain:errorMessage code:-999 userInfo:nil];
            completion(TimeSharePlatformTypeLine, errorMessage, error);
        }
        return ;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:UIImageJPEGRepresentation(image, 1.0) forPasteboardType:@"public.jpeg"];
    NSString *contentType = @"image";
    NSString *contentKey = pasteboard.name;
//    [pasteboard.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",contentType, contentKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:url];
        }
    }else{
        NSString *errorMessage = @"Line 分享失败, 没有安装Line App";
        TimeLog(errorMessage);
        if (completion) {
            NSError *error = [[NSError alloc] initWithDomain:errorMessage code:-999 userInfo:nil];
            completion(TimeSharePlatformTypeLine, errorMessage, error);
        }
    }
}

@end
