//
//  TimeFBSDKAdapter.m
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import "TimeFBSDKAdapter.h"

#if FBSDKShareModule
@interface TimeFBSDKAdapter()<FBSDKSharingDelegate>
@end
#endif

#if FBSDKLoginModule
@interface TimeFBSDKAdapter()
@property (nonatomic, strong) FBSDKLoginManager *FBLoginMgr;
@end
#endif

@interface TimeFBSDKAdapter()
@property (nonatomic, copy) TimeThirdSDKSharingCallback completionHandler;
@end


@implementation TimeFBSDKAdapter

+ (instancetype)shared {
    static TimeFBSDKAdapter *_adapter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _adapter = [[TimeFBSDKAdapter alloc] init];
    });
    return _adapter;
}

- (BOOL)existedLoginSDK {
    if (_existedLoginSDK) {
        return _existedLoginSDK;
    }
    
#if FBSDKLoginModule
    _existedLoginSDK = true;
#endif
    
    return _existedLoginSDK;
}

- (BOOL)existedSharingSDK {
    if (_existedSharingSDK) {
        return _existedSharingSDK;
    }
    
#if FBSDKShareModule
    _existedSharingSDK = true;
#endif
    
    return _existedSharingSDK;
}

#if FBSDKLoginModule // ------- 用到Facebook 登录 SDk内部东西的部分 begin --------------

- (FBSDKLoginManager *)FBLoginMgr {
    if (!_FBLoginMgr) {
        _FBLoginMgr = [FBSDKLoginManager new];
    }
    return _FBLoginMgr;
}

- (void)loginWithFromViewController:(UIViewController *)fromViewController callback:(TimeThirdSDKLoginCallback)callback {
    // 登录之前先退出登录
    [self.FBLoginMgr logOut];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        TimeLog(@"已经授权");
    }

    [self.FBLoginMgr logInWithPermissions:@[@"email", @"public_profile"]
                               fromViewController:fromViewController
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        TimeThirdSDKLoginResult *loginResult = [[TimeThirdSDKLoginResult alloc] init];
        if (error) {
            loginResult.error = error;
        } else if (result.isCancelled) {
            loginResult.isCancelled = true;
        } else {
            loginResult.token = result.token.tokenString;
        }
        
        if (callback) {
            callback(loginResult);
        }
     }];
}

#endif // ------- 用到Facebook 登录 SDk内部东西的部分 end --------------

#if FBSDKShareModule // ------- 用到Facebook、Messenger分享SDk内部东西的部分 begin --------------

- (void)shareToFacebookMessenger:(TimeSharingType)shareType
                     shareObject:(TimeSharingObject *)sharingObj
                      completion:(TimeThirdSDKSharingCallback)completion
{
    FBSDKShareMessengerURLActionButton *urlButton = [[FBSDKShareMessengerURLActionButton alloc] init];
    urlButton.title = sharingObj.title;
    urlButton.url = [NSURL URLWithString:sharingObj.webpageUrl];
        
    FBSDKShareMessengerGenericTemplateElement *element = [[FBSDKShareMessengerGenericTemplateElement alloc] init];
    element.title = sharingObj.title;
    element.subtitle = sharingObj.descr;
    element.imageURL = [NSURL URLWithString:sharingObj.shareImage];
    element.button = urlButton;
        
    FBSDKShareMessengerGenericTemplateContent *content = [[FBSDKShareMessengerGenericTemplateContent alloc] init];
//    content.pageID = @"1"; // Your page ID, required for attribution
    content.element = element;

    FBSDKMessageDialog *messageDialog = [[FBSDKMessageDialog alloc] init];
    messageDialog.delegate = self;
    messageDialog.shareContent = content;

    if ([messageDialog canShow]) {
        [messageDialog show];
    } else {
        TimeLog(@"FBSDKMessageDialog canShow = false");
    }
}

/// 分享
- (void)shareWithFromController:(UIViewController *)fromViewController
                    sharingType:(TimeSharingType)sharingType
                     sharingObj:(TimeSharingObject *)sharingObj
                     completion:(TimeThirdSDKSharingCallback)completion
{
    self.completionHandler = completion;
    
    switch (sharingType) {
        case TimeSharingType_Web_Link:
            [self shareUrlToFaceBook:sharingObj fromViewController:fromViewController];
            break;
        case TimeSharingType_Image:
            [self shareImageToFacebook:sharingObj fromViewController:fromViewController];
            break;
//        case TimeSharingType_Video:
//            [self shareVideoToFacebook:sharingObj fromViewController:fromViewController];
//            break;
        default:
        {
            NSString *errorMessage = @"Facebook 分享失败, 不支持的分享方式";
            TimeLog(errorMessage);
            if (completion) {
                NSError *error = [[NSError alloc] initWithDomain:errorMessage code:-999 userInfo:nil];
                completion(TimeSharePlatformTypeFacebook, errorMessage, error);
            }
        }
            break;
    }
}

- (void)shareUrlToFaceBook:(TimeSharingObject *)sharingObj fromViewController:(UIViewController *)fromViewController {
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.contentURL = [NSURL URLWithString:sharingObj.webpageUrl];
    linkContent.quote = sharingObj.title;
    [self shareToFacebookWithContent:linkContent fromViewController:fromViewController];
}

- (void)shareImageToFacebook:(TimeSharingObject *)sharingObj fromViewController:(UIViewController *)fromViewController {
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = sharingObj.shareImage;
    photo.userGenerated = true;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    [self shareToFacebookWithContent:content fromViewController:fromViewController];
}

- (void)shareVideoToFacebook:(TimeSharingObject *)sharingObj fromViewController:(UIViewController *)fromViewController {
    FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
    video.videoURL = [NSURL URLWithString:sharingObj.videoUrl];
    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    content.video = video;
    [self shareToFacebookWithContent:content fromViewController:fromViewController];
}

- (void)shareToFacebookWithContent:(id<FBSDKSharingContent>)content fromViewController:(UIViewController *)fromViewController {
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.shareContent = content;
    dialog.fromViewController = fromViewController;
    dialog.delegate = self;
    [dialog show];
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if (self.completionHandler) {
        self.completionHandler(TimeSharePlatformTypeFacebook, @"Facebook 分享成功", nil);
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (self.completionHandler) {
        self.completionHandler(TimeSharePlatformTypeFacebook, @"Facebook 分享失败", error);
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSString *errorMessage = @"Facebook 分享取消";
    NSError *error = [NSError errorWithDomain:errorMessage code:-999 userInfo:nil];
    if (self.completionHandler) {
        self.completionHandler(TimeSharePlatformTypeFacebook, errorMessage, error);
    }
}

#endif // ------- 用到Facebook、Messenger分享SDk内部东西的部分 end --------------
@end
