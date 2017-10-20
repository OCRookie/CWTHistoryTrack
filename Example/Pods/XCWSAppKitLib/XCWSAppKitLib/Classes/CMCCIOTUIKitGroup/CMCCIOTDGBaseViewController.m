//
//  CMCCIOTDGBaseViewController.m
//  driverGuard
//
//  Created by BigKrist on 16/3/21.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTDGBaseViewController.h"

@interface CMCCIOTDGBaseViewController ()
{
    UIView *tipBgView;
    UIView *tipView;
    ClickSureBlock sureBlock;
    
}
- (void)tapToHideTipGesture:(UITapGestureRecognizer*)targetGesture;
@end

@implementation CMCCIOTDGBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if(self.navigationController != nil && [self.navigationController.viewControllers objectAtIndex:0] != self && [self.navigationController.viewControllers count] != 1)
    {
        //        [self cmcciotSetLeftBarItemWithTitle:@"返回" Color:[UIColor whiteColor]];
        [self cmcciotSetLeftBarItemWithImage:[UIImage imageNamed:@"CMCCIOTNaviBarBack"]];
    }
    
    horizonRelativeLine = [[UIView alloc] init];
    [self.view addSubview:horizonRelativeLine];
    horizonRelativeLine.keepTopInset.equal = 0;
    horizonRelativeLine.keepLeftInset.equal = 0;
    horizonRelativeLine.keepRightInset.equal = 0;
    horizonRelativeLine.keepHeight.equal = 1;
    horizonRelativeLine.keepHorizontalCenter.equal = 0.5;
    horizonRelativeLine.backgroundColor = [UIColor clearColor];
    
    verticalRelativeLine = [[UIView alloc] init];
    [self.view addSubview:verticalRelativeLine];
    verticalRelativeLine.keepLeftInset.equal = 0;
    verticalRelativeLine.keepTopInset.equal = 0;
    verticalRelativeLine.keepBottomInset.equal = 0;
    verticalRelativeLine.keepWidth.equal = 1;
    verticalRelativeLine.keepVerticalCenter.equal = 0.5;
    verticalRelativeLine.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cmcciotDidClickLeftBtnEvent:(id)sender
{
    if(self.navigationController != nil && self.navigationController.viewControllers.count != 1 && [self.navigationController.viewControllers objectAtIndex:0] != self)
        [self.navigationController popViewControllerAnimated:YES];
    
    //    [UIColor colorWithRed:0.23 green:0.29 blue:0.33 alpha:1]
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}



#pragma mark - 
- (void)cmcciotShowTip:(NSString *)targetTip imageName:(NSString *)imageName btnDes:(NSString *)btnDes allowAutoHide:(BOOL)autoHideTag clickSureBlock:(ClickSureBlock)targetSureBlock
{
    
    if(tipBgView != nil)
    {
        [tipBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [tipBgView removeFromSuperview];
        tipBgView = nil;
        tipView = nil;
        sureBlock = nil;
    }
    
    tipBgView = [[UIView alloc] init];
    [self.view addSubview:tipBgView];
    tipBgView.keepInsets.equal = 0;
    tipBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    
    tipView = [[UIView alloc] init];
    [tipBgView addSubview:tipView];
    tipView.keepCenter.equal = 0.5;
    tipView.keepWidth.equal = [UIScreen mainScreen].bounds.size.width - 40;
    tipView.backgroundColor = [@"FFFFFF" cmcciotHexColor];
    
    UIImageView *tipImgView = nil;
    if(imageName != nil && ![imageName isStringEmpty] && [UIImage imageNamed:imageName] != nil)
    {
        tipImgView = [[UIImageView alloc] init];
        [tipView addSubview:tipImgView];
        UIImage *tempImg = [UIImage imageNamed:imageName];
        tipImgView.keepTopInset.equal = 15;
        tipImgView.keepWidth.equal = tempImg.size.width;
        tipImgView.keepHeight.equal = tempImg.size.height;
        tipImgView.keepHorizontalCenter.equal = 0.5;
        tipImgView.image = tempImg;
    }
    
    UILabel *desLabel = [[UILabel alloc] init];
    [tipView addSubview:desLabel];
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.keepHorizontalCenter.equal = 0.5;
    if(tipImgView != nil)
        desLabel.keepTopOffsetTo(tipImgView).equal = 15;
    else
        desLabel.keepTopInset.equal = 25;
    desLabel.keepWidth.equal = [UIScreen mainScreen].bounds.size.width - 40 - 20;
    desLabel.numberOfLines = 0;
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.preferredMaxLayoutWidth = desLabel.keepWidth.equal;
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = [@"242427" cmcciotHexColor];
    desLabel.text = targetTip;
    
    if(btnDes != nil && ![btnDes isStringEmpty])
    {
        desLabel.keepBottomInset.min = 60;
        
        UIButton *sureBtn = [[UIButton alloc] init];
        UIImage *sureBtnBgImg = [UIImage imageNamed:@"blueBtnBg"];
        [tipView addSubview:sureBtn];
        sureBtn.keepTopOffsetTo(desLabel).equal = 15;
        sureBtn.keepWidth.equal= sureBtnBgImg.size.width;
        sureBtn.keepHeight.equal = sureBtnBgImg.size.height;
        sureBtn.keepHorizontalCenter.equal = 0.5;
        [sureBtn setBackgroundImage:sureBtnBgImg forState:UIControlStateNormal];
        [sureBtn setTitle:btnDes forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sureBtn addTarget:self action:@selector(clickTipSureBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        desLabel.keepBottomInset.min = 25;
        //没有按钮的提示才能使用点击消失的手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideTipGesture:)];
        [tipBgView addGestureRecognizer:tapGesture];
    }
    
    tipView.layer.cornerRadius = 5;
    
    if(autoHideTag == YES)
    {
        [self performSelector:@selector(hideTipAnimated) withObject:nil afterDelay:3];
    }
    
    tipBgView.alpha = 0;
    tipView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        tipBgView.alpha = 1;
        tipView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    sureBlock = targetSureBlock;
}

- (void)clickTipSureBtnEvent:(id)sender
{
    [self hideTipAnimated];
    if(sureBlock != nil)
        sureBlock();
}


- (void)tapToHideTipGesture:(UITapGestureRecognizer *)targetGesture
{
    [self hideTipAnimated];
}


- (void)hideTipAnimated
{
    if(tipBgView == nil || tipBgView.superview == nil)
        return;
    
    [UIView animateWithDuration:0.3 animations:^{
        tipBgView.alpha = 0;
        tipView.alpha = 0;
    } completion:^(BOOL finished) {
        [tipView removeFromSuperview];
        [tipBgView removeFromSuperview];
        tipView = nil;
        tipBgView = nil;
    }];
}


#pragma mark - 
#pragma mark - Custom Methods
- (void)createCustomTopBar
{
    innerTopNaviBar = [[UIView alloc] init];
    [self.view addSubview:innerTopNaviBar];
    innerTopNaviBar.keepTopInset.equal = 0;
    innerTopNaviBar.keepLeftInset.equal = 0;
    innerTopNaviBar.keepRightInset.equal = 0;
    innerTopNaviBar.keepHorizontalCenter.equal = 0.5;
    innerTopNaviBar.keepHeight.equal = 64;
    innerTopNaviBar.backgroundColor = [@"23B7F3" cmcciotHexColor];
    
    innerTopLeftBtn = [[UIButton alloc] init];
    [innerTopNaviBar addSubview:innerTopLeftBtn];
    innerTopLeftBtn.keepLeftInset.equal = 0;
    innerTopLeftBtn.keepTopInset.equal = 20;
    innerTopLeftBtn.keepWidth.equal = 45;
    innerTopLeftBtn.keepHeight.equal = 44;
    [innerTopLeftBtn setImage:[UIImage imageNamed:@"CMCCIOTNaviBarBack"] forState:UIControlStateNormal];
    [innerTopLeftBtn addTarget:self action:@selector(cmcciotDidClickLeftBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    innerTopNaviTitleLabel = [[UILabel alloc] init];
    [innerTopNaviBar addSubview:innerTopNaviTitleLabel];
    innerTopNaviTitleLabel.keepLeftInset.equal = 0;
    innerTopNaviTitleLabel.keepRightInset.equal = 0;
    innerTopNaviTitleLabel.keepHorizontalCenter.equal = 0.5;
    innerTopNaviTitleLabel.keepHeight.equal = 44;
    innerTopNaviTitleLabel.keepTopInset.equal = 20;
    innerTopNaviTitleLabel.backgroundColor = [UIColor clearColor];
    innerTopNaviTitleLabel.userInteractionEnabled = NO;
    innerTopNaviTitleLabel.font = [UIFont systemFontOfSize:17];
    innerTopNaviTitleLabel.textColor = [UIColor whiteColor];
    innerTopNaviTitleLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)cmcciotSetCustomTitle:(NSString *)targetTitleStr
{
    if(innerTopNaviTitleLabel != nil)
        innerTopNaviTitleLabel.text = targetTitleStr;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

@end
