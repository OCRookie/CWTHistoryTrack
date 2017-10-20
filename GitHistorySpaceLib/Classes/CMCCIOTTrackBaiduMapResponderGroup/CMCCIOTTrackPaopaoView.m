//
//  CMCCIOTTrackPaopaoView.m
//  driverGuard
//
//  Created by BigKrist on 16/4/11.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTTrackPaopaoView.h"
#import "CMCCIOTAppKit.h"
@interface CMCCIOTTrackPaopaoView ()
{
    UIImageView *bgImgView;
    UILabel *timeLabel;
    UILabel *speedLabel;
    
    UILabel *timeTitleLabel;
    UILabel *stateTitleLabel;
}

@end

@implementation CMCCIOTTrackPaopaoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        bgImgView = [[UIImageView alloc] init];
        [self addSubview:bgImgView];
        bgImgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        UIImage *paopaoImg = [UIImage imageNamed:@"paopaoBg"] ;
        bgImgView.image = paopaoImg;
        
        timeTitleLabel = [[UILabel alloc] init];
        [self addSubview:timeTitleLabel];
        timeTitleLabel.frame = CGRectMake(5, 2, 35, 15);
        timeTitleLabel.font = [UIFont systemFontOfSize:13];
        
        
        timeLabel = [[UILabel alloc] init];
        [self addSubview:timeLabel];
        timeLabel.frame = CGRectMake(40, 2, 70, 15);
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [@"23B7F3" cmcciotHexColor];
        
        
        stateTitleLabel = [[UILabel alloc] init];
        [self addSubview:stateTitleLabel];
        stateTitleLabel.frame = CGRectMake(5, 25 - 3, 35, 15);
        stateTitleLabel.font = [UIFont systemFontOfSize:13];
        
        
        speedLabel = [[UILabel alloc] init];
        [self addSubview:speedLabel];
        speedLabel.frame = CGRectMake(40, 25 - 3, 70, 15);
        speedLabel.font = [UIFont systemFontOfSize:13];
        speedLabel.textColor = [@"23B7F3" cmcciotHexColor];
    }
    return self;
}

- (void)displayWithContextInfo:(NSDictionary *)dicInfo
{
    NSString *localOp_standTime = [dicInfo objectForKey:@"localOp_standTime"];
    if(localOp_standTime == nil)
    {
        stateTitleLabel.text = @"速度";
        speedLabel.text = [NSString stringWithFormat:@"%@km/h",[dicInfo objectForKey:@"speed"]];
    }
    else
    {
        stateTitleLabel.text = @"停留";
        speedLabel.text = localOp_standTime;
    }
    
    timeTitleLabel.text = @"时间";
    NSString *timeStr = [dicInfo objectForKey:@"time"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *targetDate = [dateFormatter dateFromString:timeStr];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *shownTime = [dateFormatter stringFromDate:targetDate];
    timeLabel.text = shownTime;
    
}

@end
