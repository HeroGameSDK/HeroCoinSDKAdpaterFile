//
//  TimeSharingObject.h
//  Demo
//
//  Created by 郑章海 on 2020/3/17.
//  Copyright © 2020 time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSharingObject : NSObject
/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *title;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *descr;

/**
 * 缩略图 UIImage或者NSData类型或者NSString类型（图片url）
 */
@property (nonatomic, strong) id thumbImage;

///****************分享文本内容****************
@property (nonatomic, strong) NSString *text;

///****************分享单张图片****************
/** 分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）
 * @note 图片大小根据各个平台限制而定
 */
@property (nonatomic, retain) id shareImage;

///****************分享网络链接****************
/// 链接标题
//@property (nonatomic, copy) NSString *webpageTitle;
/// 链接地址
@property (nonatomic, copy) NSString *webpageUrl;

/**
 视频网页的url
 
 @warning 不能为空且长度不能超过255
 */
@property (nonatomic, strong) NSString *videoUrl;

/// 视频数据
@property (nonatomic, strong) NSData *videoData;

@end


