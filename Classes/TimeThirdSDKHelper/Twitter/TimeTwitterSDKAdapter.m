//
//  TimeTwitterSDKAdapter.m
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import "TimeTwitterSDKAdapter.h"
#import "TimeHelper.h"

@interface TimeTwitterSDKAdapter()
@property (nonatomic, strong) UIViewController *fromViewController;
@end

@implementation TimeTwitterSDKAdapter

+ (instancetype)shared {
    static TimeTwitterSDKAdapter *_adapter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _adapter = [[TimeTwitterSDKAdapter alloc] init];
    });
    return _adapter;
}

- (BOOL)existedSDK {
    if (_existedSDK) {
        return _existedSDK;
    }
    
#if TwitterSDKModule
    _existedSDK = true;
#endif
    
    return _existedSDK;
}

#if TwitterSDKModule // ------- 用到Twitter SDk内部东西的部分 begin --------------

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {
    return [[Twitter sharedInstance] application:application openURL:url options:options];
}

/// 注册Twitter
- (void)startWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    if (IS_EMPTY_STRING(consumerKey) || IS_EMPTY_STRING(consumerSecret)) {
        TimeLog(@"twitterConsumerKey 或者 twitterConsumerSecret 为空");
        return ;
    }
    [[Twitter sharedInstance] startWithConsumerKey:consumerKey consumerSecret:consumerSecret];
}

- (void)loginWithCallback:(TimeThirdSDKLoginCallback)callback {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        TimeThirdSDKLoginResult *result = [[TimeThirdSDKLoginResult alloc] init];
        if (error) {
            result.error = error;
        } else {
            result.userId = session.userID;
            result.authToken = session.authToken;
            result.authTokenSecret = session.authTokenSecret;
        }
        
        if (callback) {
            callback(result);
        }
    }];
}

#pragma mark - 分享相关

/// 分享到Twitter前先检查Twitter，如果没登录先去登录
- (void)loginWithTwitterIfNeed:(void(^)(BOOL isSuccess, NSError *error))completion {
    //检查是否当前会话具有登录的用户
    if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
        if (completion) {
            completion(true, nil);
        }
    } else {
        // 没有用户登录的情况下，去登录
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (completion) {
                completion(session != nil, error);
            }
        }];
    }
}

- (void)shareWithFromController:(UIViewController *)fromViewController
                    sharingType:(TimeSharingType)sharingType
                     sharingObj:(TimeSharingObject *)sharingObj
                     completion:(TimeThirdSDKSharingCallback)completion
{
    self.fromViewController = fromViewController;
    __weak typeof(self) weakself = self;
    
    [self loginWithTwitterIfNeed:^(BOOL isSuccess, NSError *error) {
        if (!isSuccess) { // 登录失败
            TimeLog(@"Twitter 分享失败, Tiitter没有登录或者登录失败");
            if (completion) {
                completion(TimeSharePlatformTypeTwitter, @"Twitter 分享失败, Tiitter没有登录或者登录失败", error);
            }
            return ;
        }
        switch (sharingType) {
            case TimeSharingType_Text:
                [weakself shareTextWithObj:sharingObj completion:completion];
                break;
            case TimeSharingType_Web_Link:
                [weakself shareUrlWithObj:sharingObj completion:completion];
                break;
            case TimeSharingType_Image:
                [weakself shareImageWithObj:sharingObj completion:completion];
                break;
            case TimeSharingType_Image_Url:
                [weakself shareImageUrlWithObj:sharingObj completion:completion];
                break;
//            case TimeSocialShareType_Video:
//                [weakself shareVideoToTwitter:shareObject completion:completion];
//                break;
//            case TimeSocialShareType_Video_Link:
//                [weakself shareVideoUrlToTwitter:shareObject completion:completion];
//                break;
            default:
            {
                NSString *errorMessage = @"Twitter 分享失败, 不支持的分享方式";
                TimeLog(errorMessage);
                if (completion) {
                    NSError *error = [[NSError alloc] initWithDomain:errorMessage code:-999 userInfo:nil];
                    completion(TimeSharePlatformTypeTwitter, errorMessage, error);
                }
            }
                break;
        }
        
    }];
}

// 分享文本
- (void)shareTextWithObj:(TimeSharingObject *)sharingObj
              completion:(TimeThirdSDKSharingCallback)completion
{
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setText:sharingObj.title];
    [self shareWithComposer:composer completion:completion];
}

/// 分享URL + 文字 到twitter
- (void)shareUrlWithObj:(TimeSharingObject *)sharingObj
             completion:(TimeThirdSDKSharingCallback)completion
{
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setText:sharingObj.title];
    //注释掉添加图片方法
    [composer setURL:[NSURL URLWithString:sharingObj.webpageUrl]];
    [self shareWithComposer:composer completion:completion];
}

/// 分享图片 + url 到twitter
- (void)shareImageWithObj:(TimeSharingObject *)sharingObj
               completion:(TimeThirdSDKSharingCallback)completion
{
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setText:sharingObj.title];
    //带图片方法
    if ([sharingObj.shareImage isKindOfClass:[UIImage class]]) {
        [composer setImage:sharingObj.shareImage];
    }
    [composer setURL:[NSURL URLWithString:sharingObj.webpageUrl]];
    [self shareWithComposer:composer completion:completion];
}

/// 分享图片URL + 链接 到twitter
- (void)shareImageUrlWithObj:(TimeSharingObject *)sharingObj
                  completion:(TimeThirdSDKSharingCallback)completion
{
    TWTRComposer *composer = [[TWTRComposer alloc] init];
     [composer setText:sharingObj.title];
    //带图片方法
    if ([sharingObj.shareImage isKindOfClass:[UIImage class]]) {
        [composer setImage:sharingObj.shareImage];
    } else if ([sharingObj.shareImage isKindOfClass:[NSString class]]) {
        [composer setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sharingObj.shareImage]]]];
    }
    [composer setURL:[NSURL URLWithString:sharingObj.webpageUrl]];
    [self shareWithComposer:composer completion:completion];
}

/// 分享视频 到twitter
- (void)shareVideoWithObj:(TimeSharingObject *)sharingObj
               completion:(TimeThirdSDKSharingCallback)completion
{
    TWTRComposerViewController *composer = [TWTRComposerViewController emptyComposer];
    composer = [composer initWithInitialText:sharingObj.title image:sharingObj.thumbImage videoData:sharingObj.videoData];
    [self.fromViewController presentViewController:composer animated:YES completion:nil];
}

/// 分享视频Url 到twitter
- (void)shareVideoUrlWithObj:(TimeSharingObject *)sharingObj
                  completion:(TimeThirdSDKSharingCallback)completion
{
    TWTRComposerViewController *composer = [TWTRComposerViewController emptyComposer];
    composer = [composer initWithInitialText:sharingObj.title image:sharingObj.thumbImage videoURL:[NSURL URLWithString:sharingObj.videoUrl]];
    [self.fromViewController presentViewController:composer animated:YES completion:nil];
}

- (void)shareWithComposer:(TWTRComposer *)composer
               completion:(TimeThirdSDKSharingCallback)completion
{
    [composer showFromViewController:self.fromViewController completion:^(TWTRComposerResult result){
        BOOL isSuccess = (result != TWTRComposerResultCancelled);
        NSString *message = @"Twitter 分享成功";
        NSError *error = nil;
        if (!isSuccess) {
            error = [[NSError alloc] initWithDomain:@"Twitter 分享失败" code:-999 userInfo:nil];
            message = @"Twitter分享失败";
        }
        if (completion) {
            completion(TimeSharePlatformTypeTwitter, message, error);
        }
    }];
}

#endif // ------- 用到Twitter SDk内部东西的部分 end --------------

@end
