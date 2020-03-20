//
//  TimeThirdSDKLoginResult.h
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeThirdSDKLoginResult : NSObject
/// error
@property (nonatomic, strong) NSError *error;

/// Facebook的token
@property (nonatomic, copy) NSString *token;
/// Facebook的isCancelled
@property (nonatomic, assign) BOOL isCancelled;

/// Twitter 或者 Line 的 userId
@property (nonatomic, strong) NSString *userId;
/// Twitter的authToken
@property (nonatomic, strong) NSString *authToken;
/// Twitter的authTokenSecret
@property (nonatomic, strong) NSString *authTokenSecret;

/// Line的accessToken
@property (nonatomic, strong) NSString *accessToken;

@end

NS_ASSUME_NONNULL_END
