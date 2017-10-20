//
//  CMCCIOTShowMessageContainerView.m
//  CMCCIOTAppKit
//
//  Created by BigKrist on 15/4/21.
//  Copyright (c) 2015年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTShowMessageContainerView.h"
#import "KeepLayout.h"
#import "NSString+ColorCategory.h"

typedef enum CMCCIOTDriftViewType_{
    CMCCIOTDriftMgsType,
    CMCCIOTDriftErrorType,
    CMCCIOTDriftLoadingType
} CMCCIOTDriftViewType;

@interface CMCCIOTShowMessageContainerView ()
{
    UIActivityIndicatorView *activityView;
    UILabel *contentLabel;
    UIImageView *iconImgView;
    UIView *driftView;
}
- (void)clearContextView;
- (void)triggerCleanTheContent;
- (void)createDriftViewWithType:(CMCCIOTDriftViewType)driftType;
- (void)showDriftViewAnimationedWithAutoHiddenTag:(BOOL)needAutoHidden;
- (void)layoutContextView;
- (void)handleTapGesture:(UIGestureRecognizer*)tapGesture;
@end

@implementation CMCCIOTShowMessageContainerView


- (void)didMoveToSuperview
{
    if(self.superview != nil)
    {
        self.keepLeftInset.equal = 0;
        self.keepRightInset.equal = 0;
        self.keepBottomInset.equal = 0;
//        if([BKBaseFunctions isNewerThanIOS7])
//            self.keepTopInset.equal = 0;
//        else
//            self.keepTopInset.equal = 0;
        
        self.keepTopInset.equal = 0;
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)clearContextView
{
    if(driftView != nil)
    {
        [activityView removeFromSuperview];
        activityView = nil;
        [contentLabel removeFromSuperview];
        contentLabel = nil;
        [iconImgView removeFromSuperview];
        iconImgView = nil;
        [driftView removeFromSuperview];
        driftView = nil;
    }
}

- (void)createDriftViewWithType:(CMCCIOTDriftViewType)driftType
{
    [self clearContextView];
    driftView = [[UIView alloc] initWithFrame:CGRectZero];
    driftView.userInteractionEnabled = NO;
    [self addSubview:driftView];
    driftView.backgroundColor = [@"484d55" cmcciotHexColorWithAlpha:0.9];
    driftView.layer.cornerRadius = 5;
    driftView.alpha = 0;
    driftView.keepCenter.equal = 0.5;
    driftView.keepWidthTo(self).equal = 0.7;
    
    contentLabel = [[UILabel alloc] init];
    [driftView addSubview:contentLabel];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:17];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.keepLeftInset.equal = 10;
    contentLabel.keepRightInset.equal = 10;
    contentLabel.keepBottomInset.equal = 15;
    contentLabel.numberOfLines = 0;
    
    if(driftType == CMCCIOTDriftMgsType || driftType == CMCCIOTDriftErrorType)
    {
        iconImgView = [[UIImageView alloc] init];
        [driftView addSubview:iconImgView];
        iconImgView.keepTopInset.equal = 15;
        iconImgView.keepHorizontalCenter.equal = 0.5;
        iconImgView.keepWidth.equal = 45;
        iconImgView.keepHeight.equal = 45;
        
        contentLabel.keepTopOffsetTo(iconImgView).equal = 0;
    }
    else if(driftType == CMCCIOTDriftLoadingType)
    {
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView startAnimating];
        [driftView addSubview:activityView];
        activityView.keepTopInset.equal = 15;
        activityView.keepHorizontalCenter.equal = 0.5;
        
        contentLabel.keepTopOffsetTo(activityView).equal = 0;
    }
}

- (void)triggerCleanTheContent
{
    [UIView animateWithDuration:0.3 animations:^{
        driftView.alpha = 0;
    } completion:^(BOOL finished) {
        [self clearContextView];
        [self removeFromSuperview];
        if(self.cmcciotDelegate != nil && [self.cmcciotDelegate respondsToSelector:@selector(cmcciotDriftContainerViewHasBeenHidden)])
            [self.cmcciotDelegate cmcciotDriftContainerViewHasBeenHidden];
    }];
}

- (void)showDriftViewAnimationedWithAutoHiddenTag:(BOOL)needAutoHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        driftView.alpha = 1;
    } completion:^(BOOL finished) {
        if(needAutoHidden)
        {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            [self addGestureRecognizer:tapGesture];
            [self performSelector:@selector(triggerCleanTheContent) withObject:nil afterDelay:3.0];
        }
    }];
}

- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self triggerCleanTheContent];
}

- (void)layoutContextView
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [driftView setNeedsLayout];
    [driftView layoutIfNeeded];
    contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(contentLabel.frame);
}

- (void)cmcciotShowMessage:(NSString*)messageToShown
{
    [self createDriftViewWithType:CMCCIOTDriftMgsType];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CMCCIOTResources" ofType:@"bundle"];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *targetImgPath = [resourcesBundle pathForResource:@"ATick@2x" ofType:@"png"];
    UIImage *atickImg = [UIImage imageWithContentsOfFile:targetImgPath];
    iconImgView.image = atickImg;
    contentLabel.text = messageToShown;
    [self layoutContextView];
    [self showDriftViewAnimationedWithAutoHiddenTag:YES];
}

- (void)cmcciotShowError:(NSString*)errorToShown
{
    [self createDriftViewWithType:CMCCIOTDriftErrorType];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CMCCIOTResources" ofType:@"bundle"];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *targetImgPath = [resourcesBundle pathForResource:@"Error@2x" ofType:@"png"];
    UIImage *errorImg = [UIImage imageWithContentsOfFile:targetImgPath];
    iconImgView.image = errorImg;
    contentLabel.text = errorToShown;
    [self layoutContextView];
    [self showDriftViewAnimationedWithAutoHiddenTag:YES];
}

- (void)cmcciotStartLoadingWith:(NSString*)loadingInfo
{
    [self createDriftViewWithType:CMCCIOTDriftLoadingType];
    contentLabel.text = loadingInfo;
    [self layoutContextView];
    [self showDriftViewAnimationedWithAutoHiddenTag:NO];
}

- (void)cmcciotStopLoading
{
    [self triggerCleanTheContent];
}
@end
