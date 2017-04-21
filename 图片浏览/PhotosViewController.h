//
//  PhotosViewController.h
//  BRSupport
//
//  Created by zhaochao on 16/10/31.
//  Copyright © 2016年 lingdanet.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosModel : NSObject       //图片模型
/**
  网络缩略图URL
 */
@property (nonatomic, copy) NSString *thumb_url;

/**
  网络原图URL  如果是本地图片，只设置原图URL即可
 */
@property (nonatomic, copy) NSString *original_url;

@end



@interface PhotosViewController : UIViewController

@property (nonatomic, strong) PhotosModel *model;
@property (nonatomic, strong) UIImage *img;

/**
    当前页面
 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) void(^singleTapCallback)(UITapGestureRecognizer *tap);

@end
