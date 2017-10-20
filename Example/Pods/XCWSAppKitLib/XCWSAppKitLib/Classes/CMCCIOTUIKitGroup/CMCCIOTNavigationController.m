//
//  CMCCIOTNavigationController.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTNavigationController.h"

//#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CMCCIOTNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
//    CGPoint startPoint;
//    UIImageView *lastScreenShotView;// view
//    UIImageView *shadowImageView;
//    UIView *blackMask;
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *screenShotList;
@property (nonatomic, assign) BOOL isMoving;


@end


//static CGFloat offset_float = 0.65; // 拉伸参数
//static CGFloat min_distance = 100;  // 最小回弹距离
@implementation CMCCIOTNavigationController

- (void)dealloc
{
//    lastScreenShotView = nil;
//    shadowImageView = nil;
//    blackMask = nil;
}

//- (NSMutableArray *)screenShotList {
//    if (!_screenShotList) {
//        _screenShotList = [[NSMutableArray alloc] initWithCapacity:10];
//    }
//    return _screenShotList;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CMCCIOTResources" ofType:@"bundle"];
//    NSBundle *resourcesBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString *targetImgPath = [resourcesBundle pathForResource:@"leftside_shadow_bg@2x" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:targetImgPath];
//    shadowImageView = [[UIImageView alloc]initWithImage:image];
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(paningGestureReceive:)];
//    recognizer.delegate = self;
//    [recognizer delaysTouchesBegan];
//    [self.view addGestureRecognizer:recognizer];
    
    __weak CMCCIOTNavigationController *weakSelf = self;
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    [self.screenShotList removeLastObject];
//    return [super popViewControllerAnimated:animated];
//}
//

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(self.viewControllers.count <= 1) return NO;
    
    if([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) return NO;
    
    if(self.cmcciotNaviDelegate != nil && [self.cmcciotNaviDelegate respondsToSelector:@selector(cmcciotNavigationControllerCanBeMoved:)] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        if(![self.cmcciotNaviDelegate cmcciotNavigationControllerCanBeMoved:self])
            return NO;
    }
    
//    CGPoint translationPt = [gestureRecognizer translationInView:self.view];
//    if(translationPt.x > 0) return YES;
    return YES;
}


#pragma mark - Utility Methods -
// get the current view screen shot
//- (UIImage *)capture
//{
//    UIView *targetView = self.view;
//    if(self.tabBarController)
//    {
//        targetView = self.tabBarController.view;
//    }
//    
//    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, targetView.opaque, 0.0);
//    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}
//
//// set lastScreenShotView 's position when paning
//- (void)moveViewWithX:(float)x
//{
//    x = x>MainScreenWidth?MainScreenWidth:x;
//    x = x<0?0:x;
//    CGRect frame = self.view.frame;
//    frame.origin.x = x;
//    self.view.frame = frame;
//    // TODO
//    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float)+x*offset_float,0,MainScreenWidth,MainScreenHeight};
//    float alpha = 0.2 - (x/800);
//    blackMask.alpha = alpha;
//}
//
//- (void)gestureAnimation:(BOOL)animated {
//    if([self.cmcciotNaviDelegate respondsToSelector:@selector(cmcciotNavigationWillBePopedOut)])
//    {
//        [self.cmcciotNaviDelegate cmcciotNavigationWillBePopedOut];
//    }
//    [self.screenShotList removeLastObject];
//    [super popViewControllerAnimated:animated];
//}
//
//
//#pragma mark - Gesture Recognizer -
//- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
//{
//    // If the viewControllers has only one vc or disable the interaction, then return.
//    if (self.viewControllers.count <= 1) return;
//    
//    if([self.cmcciotNaviDelegate respondsToSelector:@selector(cmcciotNavigationControllerCanBeMoved:)]) {
//        
//        if(![self.cmcciotNaviDelegate cmcciotNavigationControllerCanBeMoved:self]) {
//            return;
//        }
//    }
//    
//    // we get the touch position by the window's coordinate
//    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
//    
//    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
//    if (recoginzer.state == UIGestureRecognizerStateBegan) {
//        
//        _isMoving = YES;
//        startPoint = touchPoint;
//        if (!self.backGroundView) {
//            CGRect frame = self.view.frame;
//            _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
//            _backGroundView.backgroundColor = [UIColor blackColor];
//            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + 20, frame.size.width , frame.size.height - (44 + 20))];
//            blackMask.backgroundColor = [UIColor blackColor];
//            [_backGroundView addSubview:blackMask];
//        }
//        
//        [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
//        [self.view addSubview:shadowImageView];
//        
//        //        shadowImageView.frame = CGRectMake(0, 0, 10, self.topViewController.view.bounds.size.height);
//        //        [self.topViewController.view addSubview:shadowImageView];
//        shadowImageView.frame = CGRectMake(-10, 44 + 20, 10, self.view.bounds.size.height-(44 + 20));
//        _backGroundView.hidden = NO;
//        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
//        UIImage *lastScreenShot = [self.screenShotList lastObject];
//        lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
//        lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,MainScreenWidth,MainScreenHeight};
//        [self.backGroundView insertSubview:lastScreenShotView belowSubview:blackMask];
//        
//        //End paning, always check that if it should move right or move left automatically
//    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
//        
//        if (touchPoint.x - startPoint.x > min_distance)
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                
//                [self moveViewWithX:MainScreenWidth];
//                
//            } completion:^(BOOL finished) {
//                [self gestureAnimation:NO];
//                
//                CGRect frame = self.view.frame;
//                
//                frame.origin.x = 0;
//                
//                self.view.frame = frame;
//                
//                _isMoving = NO;
//            }];
//        }
//        else
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self moveViewWithX:0];
//            } completion:^(BOOL finished) {
//                _isMoving = NO;
//                
//                self.backGroundView.hidden = YES;
//            }];
//            
//        }
//        return;
//        // cancal panning, alway move to left side automatically
//    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            [self moveViewWithX:0];
//        } completion:^(BOOL finished) {
//            _isMoving = NO;
//            
//            self.backGroundView.hidden = YES;
//        }];
//        
//        return;
//    }
//    // it keeps move with touch
//    if (_isMoving) {
//        [self moveViewWithX:touchPoint.x - startPoint.x];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
