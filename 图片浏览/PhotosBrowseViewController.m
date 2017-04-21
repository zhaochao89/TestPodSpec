//
//  PhotosBrowseViewController.m
//  BRSupport
//
//  Created by zhaochao on 16/10/31.
//  Copyright © 2016年 lingdanet.com. All rights reserved.
//

#import "PhotosBrowseViewController.h"

@interface PhotosBrowseViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIView *toolView;                 //顶部操作view
@property (nonatomic, strong) UILabel *pageLabel;               //页码显示label
@property (nonatomic, strong) UIButton *deleteBtn;              //删除按钮
@property (nonatomic, assign) NSInteger PageCount;              //总页数

@end

@implementation PhotosBrowseViewController

- (NSMutableArray *)viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = THEME_VIEW_BG_COLOR;
    [self setupViews];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.images.count > 0) {//传入的是本地图片
        for (int i = 0; i < self.images.count; i++) {
            PhotosViewController *photosVC = [[PhotosViewController alloc] init];
            photosVC.img = self.images[i];
            photosVC.currentPage = i;
            __weak typeof(self) weakSelf = self;
            [photosVC setSingleTapCallback:^(UITapGestureRecognizer *tap){
                [weakSelf singleTapped:tap];
            }];
            [self.viewControllers addObject:photosVC];
        }
        self.PageCount = self.images.count;
    } else {//网络图片
        for (int i = 0; i < self.photos.count; i++) {
            PhotosViewController *photosVC = [[PhotosViewController alloc] init];
            photosVC.model = self.photos[i];
            photosVC.currentPage = i;
            __weak typeof(self) weakSelf = self;
            [photosVC setSingleTapCallback:^(UITapGestureRecognizer *tap){
                [weakSelf singleTapped:tap];
            }];
            [self.viewControllers addObject:photosVC];
        }
        self.PageCount = self.photos.count;
    }
    
    //UIPageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self.pageViewController setViewControllers:@[self.viewControllers[self.index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:self.pageViewController.view];
    
    //UIPageController
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    self.pageControl.numberOfPages = self.PageCount;
    self.pageControl.currentPage = self.index;
    
    //顶部操作栏
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.toolView.backgroundColor = [UIColor colorWithPatternImage:IMAGE(@"nav_bg")];
    [self.view addSubview:self.toolView];
    [self.view bringSubviewToFront:self.toolView];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [self.toolView addSubview:backBtn];
    [backBtn setImage:[IMAGE(@"leftbar_icon_back_nor") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@2);
        make.bottom.equalTo(@0);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:[IMAGE(@"rightnav_icon_delete") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.toolView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-2);
        make.bottom.equalTo(@0);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    self.deleteBtn.hidden = self.isHiddenDeleteBtn;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.index + 1,self.PageCount];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.font = [UIFont boldSystemFontOfSize:16];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.toolView addSubview:self.pageLabel];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.mas_right);
        make.right.equalTo(self.deleteBtn.mas_left);
        make.bottom.equalTo(@0);
        make.height.equalTo(@44);
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [self.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    tap2.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap2];
    [tap1 requireGestureRecognizerToFail:tap2];
    
    [self.toolView bk_whenTapped:^{
        //do nothing
    }];
}

- (void)singleTapped:(UITapGestureRecognizer *)tap {
    if (self.toolView.hidden) {
        self.toolView.hidden = !self.toolView.hidden;
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.top = 0;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.top = -64;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        } completion:^(BOOL finished) {
            self.toolView.hidden = !self.toolView.hidden;
        }];
    }
}

#pragma mark - UIPageViewControllerDataSource, UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    PhotosViewController *photoVC = (PhotosViewController *)viewController;
    if (photoVC.currentPage >= self.PageCount - 1) {//如果是最后一页
        return nil;
    }
    return self.viewControllers[photoVC.currentPage + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    PhotosViewController *photoVC = (PhotosViewController *)viewController;
    if (photoVC.currentPage <= 0) {//如果是第一页
        return nil;
    }
    return self.viewControllers[photoVC.currentPage - 1];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    [self hiddenToolView];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished && completed) {
        PhotosViewController *photoVC = (PhotosViewController *)[pageViewController.viewControllers firstObject];
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",photoVC.currentPage + 1,self.PageCount];
        self.pageControl.currentPage = photoVC.currentPage;
    }
}

- (void)hiddenToolView {
    if (!self.toolView.hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.top = -64;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        } completion:^(BOOL finished) {
            self.toolView.hidden = YES;
        }];
    }
}

#pragma mark - event handler
- (void)backBtnPressed {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteBtnPressed:(UIButton *)btn {
    //得到当前页
    PhotosViewController *currentVC = (PhotosViewController *)[self.pageViewController.viewControllers firstObject];
    NSInteger index = currentVC.currentPage;
    NSInteger currentPage = index;
    if (self.PageCount == 1) {
        if (self.images.count > 0) {
            [self.images removeAllObjects];
            [self.viewControllers removeAllObjects];
            if (self.deleteCallback) {
                self.deleteCallback(self.images);
            }
        } else {
            [self.photos removeAllObjects];
            [self.viewControllers removeAllObjects];
            if (self.deleteCallback) {
                self.deleteCallback(self.photos);
            }
        }
        [self showHUDWithType:HUDTypeHudSuccess title:@"删除成功!" complete:nil];
        [self backBtnPressed];
        return;
    } else if (index == self.PageCount - 1) {
        [self.pageViewController setViewControllers:@[self.viewControllers[index - 1]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        //获取当前页码
        currentPage = [self.viewControllers[index - 1] currentPage] + 1;
    } else {
        [self.pageViewController setViewControllers:@[self.viewControllers[index + 1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        //获取当前页码
        currentPage = [self.viewControllers[index + 1] currentPage];
    }
    [self hiddenToolView];
    //删除数组中对应的图片
    if (self.images.count > 0) {
        [self.images removeObjectAtIndex:index];
        [self.viewControllers removeObjectAtIndex:index];
        if (self.deleteCallback) {
            self.deleteCallback(self.images);
        }
        self.PageCount = self.images.count;
    } else {
        [self.photos removeObjectAtIndex:index];
        [self.viewControllers removeObjectAtIndex:index];
        if (self.deleteCallback) {
            self.deleteCallback(self.photos);
        }
        self.PageCount = self.photos.count;
    }
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentPage,self.PageCount];
    self.pageControl.numberOfPages = self.PageCount;
    self.pageControl.currentPage = currentPage - 1;
    [self showHUDWithType:HUDTypeHudSuccess title:@"删除成功!" complete:nil];
    //重新配置viewControllers的currentPage
    [self refreshViewControllers];
}

- (void)refreshViewControllers {
    for (int i = 0; i < self.viewControllers.count; i++) {
        PhotosViewController *photosVC = (PhotosViewController *)self.viewControllers[i];
        photosVC.currentPage = i;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
