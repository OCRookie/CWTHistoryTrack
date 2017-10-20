//
//  CMCCIOTUIKitBaseViewController.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTUIKitBaseViewController.h"

@interface CMCCIOTUIKitBaseViewController ()
{
    CMCCIOTShowMessageContainerView *driftView;
}
@end

@implementation CMCCIOTUIKitBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.navigationController isKindOfClass:[CMCCIOTNavigationController class]]) {
        CMCCIOTNavigationController *nav = (CMCCIOTNavigationController *)self.navigationController;
        nav.cmcciotNaviDelegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UINavigationController*)cmcciotCreateBaseNavigationController
{
    id view = [[[self class] alloc] init];
    CMCCIOTNavigationController *nav = [[CMCCIOTNavigationController alloc] initWithRootViewController:view];
    return nav;
}

- (void)cmcciotSetTitleView:(UIView *)view
{
    self.navigationItem.titleView = view;
}

- (void)cmcciotSetLeftBarItemWithTitle:(NSString *)leftBarItemTitle
{
    if(self.navigationItem.leftBarButtonItem == nil) {
        self.navigationItem.leftBarButtonItem = [self cmcciotLeftBarItem];
    }
    
    self.navigationItem.leftBarButtonItem.image = nil;
    self.navigationItem.leftBarButtonItem.title = leftBarItemTitle;
}

- (void)cmcciotSetRightBarItemWithTitle:(NSString *)rightBarItemTitle
{
    if(self.navigationItem.rightBarButtonItem == nil) {
        self.navigationItem.rightBarButtonItem = [self cmcciotRightBarItem];
    }
    
    self.navigationItem.rightBarButtonItem.image = nil;
    self.navigationItem.rightBarButtonItem.title = rightBarItemTitle;
}

- (void)cmcciotSetLeftBarItemTitleColor:(UIColor *)color
{
    self.navigationItem.leftBarButtonItem.tintColor = color;
}

- (void)cmcciotSetRightBarItemWithTitleColor:(UIColor *)color
{
    self.navigationItem.rightBarButtonItem.tintColor = color;
}

- (void)cmcciotSetBarButtonItemColor:(UIColor *)barButtonItemColor
{
    _cmcciotBarButtonItemColor = barButtonItemColor;
    
    [self cmcciotSetLeftBarItemTitleColor:_cmcciotBarButtonItemColor];
    [self cmcciotSetRightBarItemWithTitleColor:_cmcciotBarButtonItemColor];
}

- (void)cmcciotSetLeftBarItemWithTitle:(NSString *)leftBarItemTitle Color:(UIColor *)color
{
    if(self.navigationItem.leftBarButtonItem == nil) {
        self.navigationItem.leftBarButtonItem = [self cmcciotLeftBarItem];
    }
    self.navigationItem.leftBarButtonItem.title = leftBarItemTitle;
    self.navigationItem.leftBarButtonItem.tintColor = color;
}

- (void)cmcciotSetRightBarItemWithTitle:(NSString *)rightBarItemTitle Color:(UIColor *)color
{
    if(self.navigationItem.rightBarButtonItem == nil) {
        self.navigationItem.rightBarButtonItem = [self cmcciotRightBarItem];
    }
    self.navigationItem.rightBarButtonItem.title = rightBarItemTitle;
    self.navigationItem.rightBarButtonItem.tintColor = color;
}

- (void)cmcciotSetLeftBarItemWithImage:(UIImage *)image
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(cmcciotDidClickLeftBtnEvent:)];
}

- (void)cmcciotSetRightBarItemWithImage:(UIImage *)image
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(cmcciotDidClickRightBtnEvent:)];
}



- (CGFloat)contentWidth
{
    return self.view.frame.size.width;
}

- (CGFloat)contentHeight
{
    return self.view.frame.size.height;
}

- (UIBarButtonItem *)cmcciotLeftBarItem
{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(cmcciotDidClickLeftBtnEvent:)];
    
    return barItem;
}

- (UIBarButtonItem *)cmcciotRightBarItem
{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(cmcciotDidClickRightBtnEvent:)];
    
    return barItem;
}

- (void)cmcciotDidClickLeftBtnEvent:(id)sender
{
    NSLog(@"clickLeft");
}

- (void)cmcciotDidClickRightBtnEvent:(id)sender
{
    NSLog(@"clickRight");
}


- (BOOL)cmcciotNavigationControllerCanBeMoved:(CMCCIOTNavigationController *)navigationController
{
    return YES;
}

#pragma mark 各种信息显示函数

- (CMCCIOTShowMessageContainerView*)createDriftContainerView
{
    [self cleanDriftView];
    driftView = [[CMCCIOTShowMessageContainerView alloc] init];
    driftView.cmcciotDelegate = self;
    return driftView;
}

- (void)cleanDriftView
{
    if(driftView != nil)
    {
        [driftView removeFromSuperview];
        driftView = nil;
    }
}


- (void)cmcciotDriftContainerViewHasBeenHidden
{
    [self cleanDriftView];
}


- (void)cmcciotShowMessageInfo:(NSString*)showInfo
{
    driftView = [self createDriftContainerView];
    [self.view addSubview:driftView];
    [driftView cmcciotShowMessage:showInfo];
}


- (void)cmcciotShowErrorMessage:(NSString*)errorMessage
{
    driftView = [self createDriftContainerView];
    [self.view addSubview:driftView];
    [driftView cmcciotShowError:errorMessage];
}



- (void)cmcciotStartLoadingWith:(NSString*)loadingTitle
{
    driftView = [self createDriftContainerView];
    [self.view addSubview:driftView];
    [driftView cmcciotStartLoadingWith:loadingTitle];
}



- (void)cmcciotStopLoading
{
    if(driftView != nil)
    {
        [driftView cmcciotStopLoading];
    }
}

@end
