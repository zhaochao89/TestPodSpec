//
//  PhotosViewController.m
//  BRSupport
//
//  Created by zhaochao on 16/10/31.
//  Copyright © 2016年 lingdanet.com. All rights reserved.
//
#define kScreenRatio (SCREEN_WIDTH / SCREEN_WIDTH)


#import "PhotosViewController.h"
#import "KNProgressHUD.h"

@interface PhotosViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imgv;
@property (nonatomic, strong) UIScrollView *bgScrollView;

@end

@implementation PhotosViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //图片复位
    self.bgScrollView.zoomScale = 1.0;
    self.bgScrollView.contentOffset = CGPointZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.bgScrollView.delegate = self;
    self.bgScrollView.minimumZoomScale = 1.0;
    self.bgScrollView.maximumZoomScale = 2.5;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bgScrollView];
    
    
    self.imgv = [[UIImageView alloc] init];
    [self.bgScrollView addSubview:self.imgv];
    self.imgv.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [self.imgv addGestureRecognizer:singleTap];
    //添加双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.imgv addGestureRecognizer:doubleTap];
    
    if (self.img) {//本地图片
        self.imgv.image = self.img;
        CGRect endFrame = [self frameWithImage:self.img];
        self.imgv.frame = endFrame;
        //将图片移到scrollView的中心位置
        [self centerOfScrollViewContent:self.bgScrollView];
    } else {//网络图片
        //获取缓存的缩略图作为占位图片
        UIImage *placeholderImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.model.thumb_url];
        
        KNProgressHUD *hud = [KNProgressHUD showHUDAddTo:self.view animated:YES];
        
        [self.imgv sd_setImageWithURL:[NSURL URLWithString:self.model.original_url] placeholderImage:placeholderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            CGFloat progress = (CGFloat)receivedSize / expectedSize;
            hud.progress = progress; //设置进度
            if (progress == 1) { //如果进度为1，加载圈消失
                [hud dismiss];
            }
        
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [hud dismiss];
            if (error || !image) {
                [self showHUDWithType:HUDTypeHudFailure title:@"加载失败" complete:nil];
            } else {
                CGRect endFrame = [self frameWithImage:image];
                self.imgv.frame = endFrame;
                [self.bgScrollView setContentSize:endFrame.size];
                //将图片移到scrollView的中心位置
                [self centerOfScrollViewContent:self.bgScrollView];
            }
        }];
    }
}
//单击手势
- (void)singleTapped:(UITapGestureRecognizer *)tap {
    if (self.singleTapCallback) {
        self.singleTapCallback(tap);
    }
}
//双击手势
- (void)doubleTapped:(UITapGestureRecognizer *)tap {
    if (self.bgScrollView.zoomScale > 1.0) {
        [self.bgScrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.view];
        [self.bgScrollView zoomToRect:(CGRect){{(self.bgScrollView.contentOffset.x + touchPoint.x),(self.bgScrollView.contentOffset.y + touchPoint.y)},CGSizeZero} animated:YES];
    }
}

/**
 根据图片大小设置imageView的frame并计算缩放比率

 @param img 显示的图片

 @return imageView的frame
 */
- (CGRect)frameWithImage:(UIImage *)img {
    
    CGRect endFrame = self.bgScrollView.bounds;
    CGSize imgSize = img.size;
    
    if (imgSize.width > imgSize.height) {//横屏图片,宽度设为屏幕宽，高度按img得宽高比计算
        endFrame.size.height = SCREEN_WIDTH / (imgSize.width / imgSize.height);
    } else {//竖屏图片，宽度依然设为屏幕宽，高度根据img和屏幕的宽比例计算
        endFrame.size.height = imgSize.height / (imgSize.width / SCREEN_WIDTH);
    }
    //计算缩放比率
    CGFloat newScale = imgSize.width / SCREEN_WIDTH;
    CGFloat newScaleH = imgSize.height / SCREEN_HIEGHT;
    newScale = (newScale > newScaleH) ? newScale : newScaleH;
    newScale = newScale > 2.5 ? newScale : 2.5;
    self.bgScrollView.maximumZoomScale = newScale;
    return endFrame;
    
}

- (void)centerOfScrollViewContent:(UIScrollView *)scrollView {
     // scrollView.bounds.size.width > scrollView.contentSize.width : 说明:scrollView 大小 > 图片 大小
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imgv.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgv;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerOfScrollViewContent:scrollView];
}

@end


@implementation PhotosModel

@end
