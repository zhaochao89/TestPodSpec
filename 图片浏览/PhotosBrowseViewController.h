//
//  PhotosBrowseViewController.h
//  BRSupport
//
//  Created by zhaochao on 16/10/31.
//  Copyright © 2016年 lingdanet.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosViewController.h"

@interface PhotosBrowseViewController : UIViewController
/**
    网络图片模型数组 存放PhotosModel
 */
@property (nonatomic, strong) NSMutableArray *photos;
/**
    本地图片
 */
@property (nonatomic, strong) NSMutableArray *images;
/**
    删除操作回调
 */
@property (nonatomic, copy) void(^deleteCallback)(NSMutableArray *photos);
/**
    当前显示的图片index
 */
@property (nonatomic, assign) NSInteger index;
/**
    是否隐藏删除按钮 YES：隐藏 NO：不隐藏  默认为不隐藏
 */
@property (nonatomic, assign) BOOL isHiddenDeleteBtn;

@end
