//
//  CMCCIOTDGTrackViewController.m
//  driverGuard
//
//  Created by BigKrist on 16/4/7.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTDGTrackViewController.h"
#import "CMCCIOTTrackTimeBar.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CMCCIOTZSDatePickerContainer.h"
#import "CMCCIOTDGTrackDataProvider.h"
#import "CMCCIOTTrackBaiduMapResponder.h"
#import "CMCCIOTAppKit.h"
@interface CMCCIOTDGTrackViewController ()<CMCCIOTMapTrackTimeBarDelegate,CMCCIOTZSDatePickerContainerDelegate,CMCCIOTDGTrackDataProviderDelegate>
{
    BMKMapView *baiduMapView;
    CMCCIOTTrackTimeBar *topTimeBar;
    
    //进度条
    UIView *sliderViewContainer;
    UISlider *progressSlider;
    UIButton *playAndPauseBtn;
    UIButton *lastTrackBtn;
    UIButton *nextTrackBtn;
    
    //时间选择框弹出层
    UIView *datePickerCoverView;
    CMCCIOTZSDatePickerContainer *datePickerContainer;
    
    //操作数据类
    CMCCIOTDGTrackDataProvider *trackDataProvider;
    
    //地图响应对象
    CMCCIOTTrackBaiduMapResponder *mapResponder;
    
    //播放路径的计数器
    NSInteger currentPlayingTrackPointIndex;
    NSInteger totalTrackPointCount;
    BOOL isPlayingTag;
}
- (void)createCustomView;
- (void)clickLeftMoreBtnEvent:(id)sender;
- (void)clickRightMoreBtnEvent:(id)sender;
- (void)handleTapDateCoverEvent:(id)sender;
- (void)handlePlayingTrackEvent;
- (void)cmcciotSliderValueChangedEvent:(id)sender;
- (void)cmcciotClickPauseOrPlayingBtnEvent:(id)sender;
- (NSDictionary*)cmcciotGetTrackPointInfoWithIndex:(NSInteger)targetIndex;   //根据播放到的目标轨迹点来获取点信息
- (void)cmcciotHandleUserWillLogOutNoti:(NSNotification*)targetNoti;
@end

@implementation CMCCIOTDGTrackViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cmcciotHandleUserWillLogOutNoti:) name:gNoti_UserWillLogoutNoti object:nil];
    }
    return self;
}

- (void)cmcciotHandleUserWillLogOutNoti:(NSNotification *)targetNoti
{
    
    //退出前清理资源
    if(baiduMapView != nil)
        baiduMapView.delegate = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史轨迹";
    [self createCustomView];
    
    
    currentPlayingTrackPointIndex = 0;
    totalTrackPointCount = 0;
    isPlayingTag = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSString *dateTimeStr = [dateFormatter stringFromDate:nowDate];
    [topTimeBar cmcciotSetShownTimeStr:dateTimeStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(baiduMapView != nil)
        [baiduMapView viewWillAppear];
    
    if(mapResponder == nil)
        mapResponder = [[CMCCIOTTrackBaiduMapResponder alloc] init];
    
    baiduMapView.delegate = mapResponder;
    mapResponder.weakMapView = baiduMapView;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (baiduMapView) {
        
        baiduMapView.showMapScaleBar = YES;
        baiduMapView.mapScaleBarPosition = CGPointMake(10, self.view.frame.size.height - 45 - 10 - baiduMapView.mapScaleBarSize.height);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
    if(baiduMapView != nil) {
        [baiduMapView viewWillDisappear];
    }
    
    baiduMapView.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


#pragma mark - 
#pragma mark - Business Logic

- (BOOL)cmcciotNavigationControllerCanBeMoved:(CMCCIOTNavigationController *)navigationController
{
    return NO;
}

- (void)createCustomView
{
    
    baiduMapView = [[BMKMapView alloc] init];
    //baiduMapView.minZoomLevel = 11;//10公里
    //baiduMapView.maxZoomLevel = 21;//5米
    [self.view addSubview:baiduMapView];
    baiduMapView.keepInsets.equal = 0;
    
    topTimeBar = [[CMCCIOTTrackTimeBar alloc] init];
    [self.view addSubview:topTimeBar];
    topTimeBar.keepLeftInset.equal = 0;
    topTimeBar.keepRightInset.equal = 0;
    topTimeBar.keepTopInset.equal = 0;
    topTimeBar.keepHeight.equal = 35;
    topTimeBar.keepHorizontalCenter.equal = 0.5;
    topTimeBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    topTimeBar.delegate = self;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *trackOperationBtnBg = [[UIButton alloc] init];
    [self.view addSubview:trackOperationBtnBg];
    trackOperationBtnBg.keepLeftInset.equal = 0;
    trackOperationBtnBg.keepBottomInset.equal = 0;
    trackOperationBtnBg.keepRightInset.equal = 0;
    trackOperationBtnBg.keepHeight.equal = 45;
    
    lastTrackBtn = [[UIButton alloc] init];
    [trackOperationBtnBg addSubview:lastTrackBtn];
    lastTrackBtn.keepLeftInset.equal = 0;
    lastTrackBtn.keepBottomInset.equal = 0;
    lastTrackBtn.keepTopInset.equal = 0;
    lastTrackBtn.keepWidth.equal = screenWidth/2.0 - 0.5;
    UIImage *tempBgImg = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.8]];
    UIImage *disableImg = [UIImage imageWithColor:[@"3F4040" cmcciotHexColor]];
    [lastTrackBtn setBackgroundImage:tempBgImg forState:UIControlStateNormal];
    [lastTrackBtn setBackgroundImage:disableImg forState:UIControlStateDisabled];
    //[lastTrackBtn setTitleColor:[BTN_DISABLED_COLOR cmcciotHexColor] forState:UIControlStateDisabled];
    [lastTrackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *leftMoreBtnImg = [UIImage imageNamed:@"leftMoreBtn"];
    [lastTrackBtn setImage:leftMoreBtnImg forState:UIControlStateNormal];
    UIImage *leftMoreBtnDisabledImg = [UIImage imageNamed:@"leftMoreBtnDisabled"];
    [lastTrackBtn setImage:leftMoreBtnDisabledImg forState:UIControlStateDisabled];
    [lastTrackBtn setTitle:@"上段行程" forState:UIControlStateNormal];
    [lastTrackBtn addTarget:self action:@selector(clickLeftMoreBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    nextTrackBtn = [[UIButton alloc] init];
    [trackOperationBtnBg addSubview:nextTrackBtn];
    nextTrackBtn.keepRightInset.equal = 0;
    nextTrackBtn.keepBottomInset.equal = 0;
    nextTrackBtn.keepTopInset.equal = 0;
    nextTrackBtn.keepWidth.equal = screenWidth/2.0 - 0.5;
    [nextTrackBtn setBackgroundImage:tempBgImg forState:UIControlStateNormal];
    [nextTrackBtn setBackgroundImage:disableImg forState:UIControlStateDisabled];
    UIImage *rightMoreBtnImg = [UIImage imageNamed:@"rightMoreBtn"];
    [nextTrackBtn setImage:rightMoreBtnImg forState:UIControlStateNormal];
    UIImage *rightMoreBtnDisabledImg = [UIImage imageNamed:@"rightMoreBtnDisabled"];
    [nextTrackBtn setImage:rightMoreBtnDisabledImg forState:UIControlStateDisabled];
    //[nextTrackBtn setTitleColor:[BTN_DISABLED_COLOR cmcciotHexColor] forState:UIControlStateDisabled];
    [nextTrackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextTrackBtn setTitle:@"下段行程" forState:UIControlStateNormal];
    [nextTrackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 85, 0, -85)];
    [nextTrackBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [nextTrackBtn addTarget:self action:@selector(clickRightMoreBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    playAndPauseBtn = [[UIButton alloc] init];
    [self.view addSubview:playAndPauseBtn];
    playAndPauseBtn.keepBottomOffsetTo(lastTrackBtn).equal = 30;
    playAndPauseBtn.keepLeftInset.equal = 15;
    playAndPauseBtn.keepWidth.equal = 45;
    playAndPauseBtn.keepHeight.equal = 45;
    [playAndPauseBtn setImage:[UIImage imageNamed:@"playBtnBg"] forState:UIControlStateNormal];
    [playAndPauseBtn addTarget:self action:@selector(cmcciotClickPauseOrPlayingBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    playAndPauseBtn.backgroundColor = [UIColor redColor];
    
    sliderViewContainer = [[UIView alloc] init];
    [self.view addSubview:sliderViewContainer];
  
    sliderViewContainer.keepHeight.equal = 20;
    sliderViewContainer.keepHorizontalAlignTo(playAndPauseBtn).equal= 0;
    sliderViewContainer.keepRightInset.equal=30;
    sliderViewContainer.keepLeftOffsetTo(playAndPauseBtn).equal=15;
    sliderViewContainer.backgroundColor = [UIColor clearColor];
    
    progressSlider = [[UISlider alloc] init];
    [sliderViewContainer addSubview:progressSlider];
    
    progressSlider.keepInsets.equal=0;
    
    progressSlider.userInteractionEnabled = YES;
    [progressSlider setThumbImage:[UIImage imageNamed:@"slidePoint"] forState:UIControlStateNormal];
    UIImage *newSlideTagImg  = [[UIImage imageNamed:@"slideTagImg"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 10, 3, 10)];
    UIImage *pastSlideTagImg = [[UIImage imageNamed:@"slideLeftTagImg"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 10, 3, 10)];
    [progressSlider setMaximumTrackImage:newSlideTagImg forState:UIControlStateNormal];
    [progressSlider setMinimumTrackImage:pastSlideTagImg forState:UIControlStateNormal];
    [progressSlider addTarget:self action:@selector(cmcciotSliderValueChangedEvent:) forControlEvents:UIControlEventValueChanged];
    [progressSlider addTarget:self
                       action:@selector(cmcciotSliderDragExitEvent:)
             forControlEvents:UIControlEventTouchUpInside];
}


- (void)cmcciotZSToGetMapTrack
{
    /*
     "token" : "de0a0faed18d3b8da2d33701cc2b2891",
     "params" : {
     "startTime" : "2017-10-11 00:00:00",
     "deviceId" : "3613040012005069",
     "endTime" : "2017-10-11 23:59:59",
     "userId" : "16011314160721056"
     }*/
    self.currentDeviceId = @"3613040012005069";
    
    //停止轨迹播放，清除地图轨迹
    [mapResponder cmcciotClearAnnotaionAndOverlay];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handlePlayingTrackEvent) object:nil];
    isPlayingTag = NO;
    sliderViewContainer.userInteractionEnabled = NO;
    UIImage* playImg = [UIImage imageNamed:@"playBtnBg"];
    
    [playAndPauseBtn setImage:[UIImage imageNamed:@"playBtnBg"] forState:UIControlStateNormal];
    progressSlider.value = 0;
    currentPlayingTrackPointIndex = 0;
    totalTrackPointCount = 0;
    
    //开始请求新的轨迹
    if(topTimeBar == nil) return;
    NSString *targetNewTimeStr = [topTimeBar cmcciotGetShownTimeStr];
    if(targetNewTimeStr == nil)
        return;

    if(self.currentDeviceId == nil)
        return;

//    CMCCIOTUserDataModel *nowLoginUser = [[CMCCIOTGlobalUserDataManager shareInstance] cmcciotGetNowLoginUser];
//    if(nowLoginUser == nil || nowLoginUser.userId == nil)
//        return;

    NSString *beginTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",targetNewTimeStr];
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",targetNewTimeStr];

    if(trackDataProvider == nil)
    {
        trackDataProvider = [[CMCCIOTDGTrackDataProvider alloc] init];
        trackDataProvider.delegate = self;
    }

    [self cmcciotStartLoadingWith:@"获取轨迹中.."];
    [trackDataProvider cmcciotGetTrackWith:@"16011314160721056" deviceId:self.currentDeviceId trackBeginTime:beginTimeStr trackEndTime:endTimeStr];

}

- (void)handlePlayingTrackEvent
{
    
    
    NSInteger segIndex = [self cmcciotGetSegIndexWithCurrentIndex:currentPlayingTrackPointIndex];
    if (segIndex == -1) {
        //异常情况
        lastTrackBtn.enabled = NO;
        lastTrackBtn.enabled = NO;
    } else if (segIndex == 0 || segIndex == [[mapResponder cmcciotGetInnerTrackArray] count] - 1) {
        
        if (segIndex == 0) {
            lastTrackBtn.enabled = NO;
        } else {
            lastTrackBtn.enabled = YES;
        }
        
        if (segIndex == [[mapResponder cmcciotGetInnerTrackArray] count] - 1) {
            nextTrackBtn.enabled = NO;
        } else {
            nextTrackBtn.enabled = YES;
        }
    } else {
        
        lastTrackBtn.enabled = YES;
        nextTrackBtn.enabled = YES;
    }
    
    //播放处理逻辑
    
    
    NSDictionary *retDicInfo = [self cmcciotGetTrackPointInfoWithIndex:currentPlayingTrackPointIndex];
    if(retDicInfo == nil)
    {
        [self cmcciotShowErrorMessage:@"该时间段没有轨迹信息"];
        return;
    }
    
//    [retDicInfo setObject:@"pointInfo" forKey:pointInfo];
//    [retDicInfo setObject:[NSNumber numberWithBool:isFirstSeg] forKey:@"isFirstSeg"];
//    [retDicInfo setObject:[NSNumber numberWithBool:isLastSeg] forKey:@"isLastSeg"];
//    if(segTargetIndex == segArray.count - 1)
//        isEndOfSeg = YES;
//    [retDicInfo setObject:[NSNumber numberWithBool:isEndOfSeg] forKey:@"isEndOfSeg"];
    
    
    NSDictionary *targetDicInfo = [retDicInfo objectForKey:@"pointInfo"];
    //BOOL isFirstSeg = [[retDicInfo objectForKey:@"isFirstSeg"] boolValue];
    //BOOL isLastSeg = [[retDicInfo objectForKey:@"isLastSeg"] boolValue];
    BOOL isEndOfSeg = [[retDicInfo objectForKey:@"isEndOfSeg"] boolValue];
    
    NSInteger delaySeconds = 1;
    if(isEndOfSeg)
        delaySeconds = 2;
    
    progressSlider.value = currentPlayingTrackPointIndex;
    [mapResponder cmcciotSetTheMovingPointDic:targetDicInfo];
    if(isPlayingTag)
    {
        [self performSelector:@selector(handlePlayingTrackEvent) withObject:nil afterDelay:delaySeconds];
        currentPlayingTrackPointIndex++;
        
        if(currentPlayingTrackPointIndex > totalTrackPointCount)
        {
            //播放完成，应该停止了
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handlePlayingTrackEvent) object:nil];
            currentPlayingTrackPointIndex = totalTrackPointCount;
            isPlayingTag = NO;
            [playAndPauseBtn setImage:[UIImage imageNamed:@"playBtnBg"] forState:UIControlStateNormal];
        }
    }
}

- (void)cmcciotSliderValueChangedEvent:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handlePlayingTrackEvent) object:nil];
    currentPlayingTrackPointIndex = progressSlider.value;
    [self handlePlayingTrackEvent];
}

- (void)cmcciotSliderDragExitEvent:(id)sender
{
    
    currentPlayingTrackPointIndex = progressSlider.value;
    [self handlePlayingTrackEvent];
}

- (NSDictionary*)cmcciotGetTrackPointInfoWithIndex:(NSInteger)targetIndex
{
    if(mapResponder != nil)
    {
        NSArray *tempTrackArray = [mapResponder cmcciotGetInnerTrackArray];
        if(tempTrackArray == nil || tempTrackArray.count == 0)
            return nil;
        NSArray *segArray = nil;
        NSInteger segTargetIndex = -1;
        NSInteger segBeginIndex = 0;
        NSInteger segCount = 0;
        BOOL isFirstSeg = NO;
        BOOL isLastSeg = NO;
        NSInteger countIndex = 0;
        for(NSArray *subArray in tempTrackArray)
        {
            segArray = subArray;
            segCount += segArray.count;
            if(targetIndex >= segBeginIndex && targetIndex <= segCount - 1)
            {
                segTargetIndex = targetIndex - (segCount - segArray.count);
                if(countIndex == 0)
                    isFirstSeg = YES;
                
                if(countIndex == tempTrackArray.count - 1)
                    isLastSeg = YES;
                break;
            }
            
            
            segBeginIndex += segArray.count;
            countIndex ++;
        }
        
        
        if(segTargetIndex < 0 || segArray == nil)
            return nil;
        
        
        NSDictionary *pointInfo = [segArray objectAtIndex:segTargetIndex];
        BOOL isEndOfSeg = NO;
        NSMutableDictionary *retDicInfo = [[NSMutableDictionary alloc] init];
        [retDicInfo setObject:pointInfo forKey:@"pointInfo"];
        [retDicInfo setObject:[NSNumber numberWithBool:isFirstSeg] forKey:@"isFirstSeg"];
        [retDicInfo setObject:[NSNumber numberWithBool:isLastSeg] forKey:@"isLastSeg"];
        if(segTargetIndex == segArray.count - 1)
            isEndOfSeg = YES;
        [retDicInfo setObject:[NSNumber numberWithBool:isEndOfSeg] forKey:@"isEndOfSeg"];
        return retDicInfo;
    }
    
    return nil;
}

- (NSInteger)cmcciotGetLastSegIndexWithCurrentIndex:(NSInteger)targetCurrentIndex
{
    if(mapResponder != nil)
    {
        NSArray *tempTrackArray = [mapResponder cmcciotGetInnerTrackArray];
        if(tempTrackArray == nil || tempTrackArray.count == 0)
            return -1;
        NSArray *segArray = nil;
        NSInteger segTargetIndex = -1;
        NSInteger segBeginIndex = 0;
        NSInteger segCount = 0;
        BOOL isFirstSeg = NO;
        BOOL isLastSeg = NO;
        NSInteger countIndex = 0;
        for(NSArray *subArray in tempTrackArray)
        {
            segArray = subArray;
            segCount += segArray.count;
            if(targetCurrentIndex >= segBeginIndex && targetCurrentIndex <= segCount - 1)
            {
                segTargetIndex = targetCurrentIndex - (segCount - segArray.count);
                if(countIndex == 0)
                    isFirstSeg = YES;
                
                if(countIndex == tempTrackArray.count - 1)
                    isLastSeg = YES;
                break;
            }
            
            
            segBeginIndex += segArray.count;
            countIndex ++;
        }
        
        
        if(countIndex == 0)
            return -1;
        
        
        NSInteger retCountIndex = 0;
        for(NSInteger subTempIndex = 0; subTempIndex < countIndex - 1; subTempIndex++)
        {
            retCountIndex += [[tempTrackArray objectAtIndex:subTempIndex] count];
        }
        
        return retCountIndex;
    }
    
    return -1;
}

- (NSInteger)cmcciotGetNextSegIndexWithCurrentIndex:(NSInteger)targetCurrentIndex
{
    if(mapResponder != nil)
    {
        NSArray *tempTrackArray = [mapResponder cmcciotGetInnerTrackArray];
        if(tempTrackArray == nil || tempTrackArray.count == 0)
            return -1;
        NSArray *segArray = nil;
        NSInteger segTargetIndex = -1;
        NSInteger segBeginIndex = 0;
        NSInteger segCount = 0;
        BOOL isFirstSeg = NO;
        BOOL isLastSeg = NO;
        NSInteger countIndex = 0;
        for(NSArray *subArray in tempTrackArray)
        {
            segArray = subArray;
            segCount += segArray.count;
            if(targetCurrentIndex >= segBeginIndex && targetCurrentIndex <= segCount - 1)
            {
                segTargetIndex = targetCurrentIndex - (segCount - segArray.count);
                if(countIndex == 0)
                    isFirstSeg = YES;
                
                if(countIndex == tempTrackArray.count - 1)
                    isLastSeg = YES;
                break;
            }
            
            
            segBeginIndex += segArray.count;
            countIndex ++;
        }
        
        
        
        if(countIndex == tempTrackArray.count - 1)
            return -1;
        
        NSInteger retCountIndex = 0;
        for(NSInteger subTempIndex = 0; subTempIndex < countIndex + 1; subTempIndex++)
        {
            retCountIndex += [[tempTrackArray objectAtIndex:subTempIndex] count];
        }
        
        return retCountIndex;
    }
    
    return -1;
}

- (NSInteger)cmcciotGetSegIndexWithCurrentIndex:(NSInteger)targetCurrentIndex
{
    if(mapResponder != nil)
    {
        NSArray *tempTrackArray = [mapResponder cmcciotGetInnerTrackArray];
        if(tempTrackArray == nil || tempTrackArray.count == 0)
            return -1;
        NSArray *segArray = nil;
        NSInteger segTargetIndex = -1;
        NSInteger segBeginIndex = 0;
        NSInteger segCount = 0;
        BOOL isFirstSeg = NO;
        BOOL isLastSeg = NO;
        NSInteger countIndex = 0;
        for(NSArray *subArray in tempTrackArray)
        {
            segArray = subArray;
            segCount += segArray.count;
            if(targetCurrentIndex >= segBeginIndex && targetCurrentIndex <= segCount - 1)
            {
                segTargetIndex = targetCurrentIndex - (segCount - segArray.count);
                if(countIndex == 0)
                    isFirstSeg = YES;
                
                if(countIndex == tempTrackArray.count - 1)
                    isLastSeg = YES;
                break;
            }
            
            
            segBeginIndex += segArray.count;
            countIndex ++;
        }
        
        return countIndex;
    } else {
        return -1;
    }
    
    
}
#pragma mark -
#pragma mark - User Interative Events
- (void)clickLeftMoreBtnEvent:(id)sender
{
       NSInteger lastBeginIndex = [self cmcciotGetLastSegIndexWithCurrentIndex:currentPlayingTrackPointIndex];
    if(lastBeginIndex < 0){
        [self cmcciotShowErrorMessage:@"没有上段行程"];
        return;
    }
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handlePlayingTrackEvent) object:nil];
    currentPlayingTrackPointIndex = lastBeginIndex;
    [self handlePlayingTrackEvent];
}

- (void)clickRightMoreBtnEvent:(id)sender
{

    NSInteger nextBeginIndex = [self cmcciotGetNextSegIndexWithCurrentIndex:currentPlayingTrackPointIndex];
    if(nextBeginIndex < 0){
        [self cmcciotShowErrorMessage:@"没有下段行程"];
        return;
    }
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handlePlayingTrackEvent) object:nil];
    currentPlayingTrackPointIndex = nextBeginIndex;
    [self handlePlayingTrackEvent];
}

- (void)cmcciotShowDatePickerWithContextInfo:(id)targetContextInfo maxDate:(NSDate*)targetMaxDate minDate:(NSDate*)targetMinDate selectedDate:(NSDate*)targetSelectedDate
{
    if(datePickerCoverView != nil) return;
    if(datePickerContainer != nil) return;
    
    datePickerCoverView = [[UIView alloc] init];
    [self.view addSubview:datePickerCoverView];
    datePickerCoverView.keepInsets.equal = 0;
    datePickerCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    datePickerCoverView.alpha = 0;
    [self.view layoutIfNeeded];
    
    datePickerContainer = [[CMCCIOTZSDatePickerContainer alloc] init];
    datePickerContainer.delegate = self;
    datePickerContainer.contextInfo = targetContextInfo;
    [datePickerContainer cmcciotSetPickMaxDate:targetMaxDate minDate:targetMinDate];
    [datePickerContainer cmcciotSetPickerDate:targetSelectedDate];
    [datePickerContainer cmcciotSetPickerMode:UIDatePickerModeDate];
    [datePickerCoverView addSubview:datePickerContainer];
    datePickerContainer.keepBottomInset.equal = -200;
    datePickerContainer.keepLeftInset.equal = 0;
    datePickerContainer.keepRightInset.equal = 0;
    datePickerContainer.keepHorizontalCenter.equal = 0.5;
    datePickerContainer.keepHeight.equal = 200;
    
    [datePickerCoverView layoutIfNeeded];
    
    [datePickerContainer.keepBottomInset deactivate];
    datePickerContainer.keepBottomInset.equal = 0;
    __weak UIView *weakPickerCoverView = datePickerCoverView;
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        [weakPickerCoverView layoutIfNeeded];
        weakPickerCoverView.alpha = 1;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(handleTapDateCoverEvent:)];
        [weakPickerCoverView addGestureRecognizer:tapGesture];
    }];
}


- (void)handleTapDateCoverEvent:(id)sender
{
    [self cmcciotUserCanclePicker:datePickerContainer];
}

- (void)cmcciotClickPauseOrPlayingBtnEvent:(id)sender
{
   
    if(isPlayingTag)
    {
        //正在播放，要置为暂停
        [playAndPauseBtn setImage:[UIImage imageNamed:@"playBtnBg"] forState:UIControlStateNormal];
        isPlayingTag = !isPlayingTag;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handlePlayingTrackEvent) object:nil];
    }
    else
    {
        //停止状态，要置为播放
        [playAndPauseBtn setImage:[UIImage imageNamed:@"pauseBtnBg"] forState:UIControlStateNormal];
        isPlayingTag = !isPlayingTag;
        if (currentPlayingTrackPointIndex == totalTrackPointCount) {
            currentPlayingTrackPointIndex = 0;
        }
        [self handlePlayingTrackEvent];
    }
    
    
}

#pragma mark -
#pragma mark - CMCCIOTMapTrackTimeBarDelegate
- (void)cmcciotMapTrackTimeBarTimeChanged:(NSString *)targetNewTimeStr
{
    [self cmcciotZSToGetMapTrack];
}

- (void)cmcciotMapTrackTimeBarUserTapped
{
    if(topTimeBar == nil) return;
    NSString *shownTimeStr = [topTimeBar cmcciotGetShownTimeStr];
    NSString *targetShownTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",shownTimeStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *targetSelectedDate = [dateFormatter dateFromString:targetShownTimeStr];
    
    NSDate *nowDate = [NSDate date];
    NSDate *earlistDate = [nowDate dateByAddingTimeInterval:60*60*24*90*(-1)];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
    NSString *earlistDateStr = [dateFormatter stringFromDate:earlistDate];
    NSString *endOfNowDateStr = [NSString stringWithFormat:@"%@ 23:59:59",nowDateStr];
    NSString *beginOfDateStr = [NSString stringWithFormat:@"%@ 00:00:00",earlistDateStr];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *minDate = [dateFormatter dateFromString:beginOfDateStr];
    NSDate *maxDate = [dateFormatter dateFromString:endOfNowDateStr];
    
    [self cmcciotShowDatePickerWithContextInfo:nil maxDate:maxDate minDate:minDate selectedDate:targetSelectedDate];
    
}

- (void)cmcciotMapTrackTimeBarWarning:(NSString *)warning{
    [self cmcciotShowErrorMessage:warning];
}

#pragma mark -
#pragma mark - CMCCIOTZSDatePickerContainerDelegate
- (void)cmcciotUserCanclePicker:(CMCCIOTZSDatePickerContainer *)targetPicker
{
    if(datePickerContainer == nil)
        return;
    
    if(datePickerCoverView == nil)
        return;
    
    [datePickerContainer.keepBottomInset deactivate];
    datePickerContainer.keepBottomInset.equal = -200;
    __weak CMCCIOTZSDatePickerContainer *weakDatePicker = datePickerContainer;
    __weak UIView *weakCoverView = datePickerCoverView;
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.view layoutIfNeeded];
        weakCoverView.alpha = 0;
    } completion:^(BOOL finished) {
        if(weakDatePicker == nil) return;
        if(weakCoverView == nil) return;
        NSArray *tempGestrues = [weakCoverView gestureRecognizers];
        for(UIGestureRecognizer *subGes in tempGestrues)
        {
            [weakCoverView removeGestureRecognizer:subGes];
        }
        [weakCoverView removeFromSuperview];
        [weakDatePicker removeFromSuperview];
        [weakSelf cmcciotZSClearDatePicker];
    }];
}

- (void)cmcciotUserSubmitTime:(NSDate *)dateTime contextInfo:(id)contextInfo pickerContainer:(CMCCIOTZSDatePickerContainer *)targetPicke
{
   
    if(datePickerContainer == nil)
        return;
    
    if(datePickerCoverView == nil)
        return;
    
    if(dateTime != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *newShownStr = [dateFormatter stringFromDate:dateTime];
        if(newShownStr != nil && topTimeBar != nil)
            [topTimeBar cmcciotSetShownTimeStr:newShownStr];
    }
    
    [datePickerContainer.keepBottomInset deactivate];
    datePickerContainer.keepBottomInset.equal = -200;
    __weak CMCCIOTZSDatePickerContainer *weakDatePicker = datePickerContainer;
    __weak UIView *weakCoverView = datePickerCoverView;
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.view layoutIfNeeded];
        weakCoverView.alpha = 0;
    } completion:^(BOOL finished) {
        if(weakDatePicker == nil) return;
        if(weakCoverView == nil) return;
        NSArray *tempGestrues = [weakCoverView gestureRecognizers];
        for(UIGestureRecognizer *subGes in tempGestrues)
        {
            [weakCoverView removeGestureRecognizer:subGes];
        }
        [weakCoverView removeFromSuperview];
        [weakDatePicker removeFromSuperview];
        [weakSelf cmcciotZSClearDatePicker];
    }];
}

- (void)cmcciotZSClearDatePicker
{
    datePickerContainer = nil;
    datePickerCoverView = nil;
}

#pragma mark - 
#pragma mark - CMCCIOTDGTrackDataProviderDelegate
- (void)cmcciotDGGetTrackFailedWith:(NSError*)error
{
    [self cmcciotShowErrorMessage:error.domain];
    
    currentPlayingTrackPointIndex = 0;
    totalTrackPointCount = 0;
    progressSlider.maximumValue = totalTrackPointCount;
    progressSlider.minimumValue = 0;
    progressSlider.value = currentPlayingTrackPointIndex;
    sliderViewContainer.userInteractionEnabled = NO;
    playAndPauseBtn.enabled = NO;
    
    nextTrackBtn.enabled = NO;
    lastTrackBtn.enabled = NO;
}

- (void)cmcciotDGGetTrackSuccessWith:(NSArray*)retArray
{
    [self cmcciotStopLoading];
    
    CMCCIOTLOG(@"retArray is %@",retArray);
    if(retArray == nil || retArray.count == 0)
    {
        playAndPauseBtn.enabled = NO;
        return;
    }
    
    lastTrackBtn.enabled = NO;
    nextTrackBtn.enabled = YES;
    if(retArray == nil || retArray.count < 2)
    {
        nextTrackBtn.enabled = NO;
    }
    
    if(mapResponder != nil)
        [mapResponder cmcciotAddTracks:retArray];
    
    
    NSInteger tempCount = 0;
    for(NSArray *subArray in retArray)
    {
        if(subArray == nil || ![subArray isKindOfClass:[NSArray class]])
            continue;
        
        tempCount += subArray.count;
    }
    
    totalTrackPointCount = tempCount - 1;
    currentPlayingTrackPointIndex = 0;
    progressSlider.maximumValue = totalTrackPointCount;
    progressSlider.minimumValue = 0;
    progressSlider.value = currentPlayingTrackPointIndex;
    sliderViewContainer.userInteractionEnabled = YES;
    playAndPauseBtn.enabled = YES;
}


@end
