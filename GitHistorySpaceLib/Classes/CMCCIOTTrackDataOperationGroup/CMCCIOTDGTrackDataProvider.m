//
//  CMCCIOTDGTrackDataProvider.m
//  driverGuard
//
//  Created by BigKrist on 16/4/8.
//  Copyright © 2016年 CMCCIOT. All rights reserved.
//

#import "CMCCIOTDGTrackDataProvider.h"
#import "CMCCIOTAppKit.h"
#import "CMCCIOTDGNetHelper.h"
@implementation CMCCIOTDGTrackDataProvider
- (void)cmcciotGetTrackWith:(NSString *)userId deviceId:(NSString *)targetDeviceId trackBeginTime:(NSString *)trackBeginTime trackEndTime:(NSString *)trackEndTime
{
    if(self.delegate == nil) return;
    if(![self.delegate respondsToSelector:@selector(cmcciotDGGetTrackFailedWith:)]) return;
    if(![self.delegate respondsToSelector:@selector(cmcciotDGGetTrackSuccessWith:)]) return;
    
    if(userId == nil || [userId isStringEmpty] || targetDeviceId == nil || [targetDeviceId isStringEmpty] || trackBeginTime == nil || [trackBeginTime isStringEmpty] || trackEndTime == nil || [trackEndTime isStringEmpty])
    {
        NSError *retError = [[NSError alloc] initWithDomain:@"缺失关键参数" code:-1 userInfo:nil];
        [self.delegate cmcciotDGGetTrackFailedWith:retError];
        return;
    }
    
    NSDictionary *dicOrigin = @{@"userId":userId,@"deviceId":targetDeviceId,@"startTime":trackBeginTime,@"endTime":trackEndTime};
    NSMutableDictionary *dicToPost = [[CMCCIOTDGNetHelper shareInstance] cmcciotDGCreatePostInfoWith:@"queryDeviceTrackList" params:dicOrigin];
    [dicToPost setObject:@"de0a0faed18d3b8da2d33701cc2b2891" forKey:@"token"];
    WS(weakSelf);
    [[CMCCIOTDGNetHelper shareInstance] cmcciotDGPostParams:dicToPost successBlock:^(id retValue) {
        if(weakSelf == nil) return;
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:retValue options:nil error:&parseError];
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       
        NSArray *retArray = [weakSelf createTrackArrayWith:retValue];
        [weakSelf.delegate cmcciotDGGetTrackSuccessWith:retArray];
    } failBlock:^(NSError *error, id contextInfo) {
        if(weakSelf == nil) return;
        [weakSelf.delegate cmcciotDGGetTrackFailedWith:error];
    }];
}


- (NSArray*)createTrackArrayWith:(NSDictionary*)originDicInfo
{
    if(originDicInfo == nil)
        return nil;
    
//    “metadata”: [“lng”, “lat”, “time”, “speed”, “posMethod”, “onlineStatus”,” segmentNum”],
    NSArray *metaDataArray = [originDicInfo objectForKey:@"metadata"];
    NSArray *originDataArray = [originDicInfo objectForKey:@"data"];
    if(metaDataArray == nil || ![metaDataArray isKindOfClass:[NSArray class]])
        return nil;
    
    NSInteger metaCount = metaDataArray.count;
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    NSString *tagSeg = nil;
    NSMutableArray *tempTagArray = nil;
    NSInteger countIndex = 0;
    
    NSInteger timeMetaIndex = [metaDataArray indexOfObject:@"time"];
    NSInteger speedMetaIndex = [metaDataArray indexOfObject:@"speed"];
    NSInteger posMethodMetaIndex = [metaDataArray indexOfObject:@"posMethod"];
    NSInteger lngMetaIndex = [metaDataArray indexOfObject:@"lng"];
    NSInteger latMetaIndex = [metaDataArray indexOfObject:@"lat"];
    NSInteger onlineStatusMetaIndex = [metaDataArray indexOfObject:@"onlineStatus"];
    NSInteger segMentNumMetaIndex = [metaDataArray indexOfObject:@"segmentNum"];
    
    for(NSArray *subPointInfoArray in originDataArray)
    {
        if(![subPointInfoArray isKindOfClass:[NSArray class]])
            continue;
        
        if(subPointInfoArray.count != metaCount)
            continue;
        
        NSString *subLng = [subPointInfoArray objectAtIndex:lngMetaIndex];
        NSString *subLati = [subPointInfoArray objectAtIndex:latMetaIndex];
        NSString *subTrackTime = [subPointInfoArray objectAtIndex:timeMetaIndex];
        NSString *subSpeed = [subPointInfoArray objectAtIndex:speedMetaIndex];
        NSString *subPosMethod = [subPointInfoArray objectAtIndex:posMethodMetaIndex];
        NSString *subOnlineStatus = [subPointInfoArray objectAtIndex:onlineStatusMetaIndex];
        NSString *subSegmentNum = [subPointInfoArray objectAtIndex:segMentNumMetaIndex];
        
        NSMutableDictionary *dicToAdd = [[NSMutableDictionary alloc] init];
        [dicToAdd setObject:subLng forKey:@"lng"];
        [dicToAdd setObject:subLati forKey:@"lat"];
        [dicToAdd setObject:subTrackTime forKey:@"time"];
        [dicToAdd setObject:subSpeed forKey:@"speed"];
        [dicToAdd setObject:subPosMethod forKey:@"posMethod"];
        [dicToAdd setObject:subOnlineStatus forKey:@"onlineStatus"];
        [dicToAdd setObject:subSegmentNum forKey:@"segmentNum"];
        
        if(tempTagArray == nil)
            tempTagArray = [[NSMutableArray alloc] init];
        
        if(tagSeg == nil)
            tagSeg = subSegmentNum;
        
        if([subSegmentNum isEqualToString:tagSeg])
        {
            [tempTagArray addObject:dicToAdd];
        }
        else
        {
            if(tempTagArray != nil)
                [retArray addObject:tempTagArray];
            
            tempTagArray = nil;
            tagSeg = subSegmentNum;
            tempTagArray = [[NSMutableArray alloc] init];
            [tempTagArray addObject:dicToAdd];
        }
        
        if(countIndex == originDataArray.count - 1)
        {
            [retArray addObject:tempTagArray];
            break;
        }
        
        countIndex++;
    }
    
    for(NSInteger index = 0; index < retArray.count; index++)
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        if(index != retArray.count - 1)
        {
            NSMutableArray *oneArray = [retArray objectAtIndex:index];
            NSMutableArray *twoArray = [retArray objectAtIndex:index + 1];
            NSMutableDictionary *endOfOneArray = [oneArray lastObject];
            NSMutableDictionary *beginOfTwoArray = [twoArray firstObject];
            
            NSString *endOfOneArrayTime = [endOfOneArray objectForKey:@"time"];
            NSString *beginOfTwoArrayTime = [beginOfTwoArray objectForKey:@"time"];
            
            NSDate *endOfOneSegDate = [dateFormatter dateFromString:endOfOneArrayTime];
            NSDate *beginOfTwoSegDate = [dateFormatter dateFromString:beginOfTwoArrayTime];
            
            NSTimeInterval timeInterval = [beginOfTwoSegDate timeIntervalSinceDate:endOfOneSegDate];
            if(timeInterval < 0)
                timeInterval = timeInterval*(-1);
            
            NSString *standTimeSpace = nil;
            if(timeInterval >= 3600)
            {
                //小时
                NSInteger tempIntegerValue = (NSInteger)timeInterval;
                NSInteger hourValue = tempIntegerValue/3600;
                NSInteger minValue = (tempIntegerValue%3600)/60;
                NSInteger secondValue = (tempIntegerValue%3600)%60;
                if(minValue == 0 && secondValue == 0)
                    standTimeSpace = [NSString stringWithFormat:@"%ldh",(long)hourValue];
                else if(minValue != 0 && secondValue == 0)
                    standTimeSpace = [NSString stringWithFormat:@"%ldh%02ldm",(long)hourValue,(long)minValue];
                else
                    standTimeSpace = [NSString stringWithFormat:@"%ldh%02ldm%02lds",(long)hourValue,(long)minValue,(long)secondValue];
            }
            else if(timeInterval >= 60)
            {
                //分钟
                NSInteger tempIntegerValue = (NSInteger)timeInterval;
                NSInteger minValue = tempIntegerValue/60;
                NSInteger secondValue = tempIntegerValue%60;
                if(secondValue == 0)
                    standTimeSpace = [NSString stringWithFormat:@"%ldmin",(long)minValue];
                else
                    standTimeSpace = [NSString stringWithFormat:@"%ldm%02lds",(long)minValue,(long)secondValue];
            }
            else
            {
                //秒
                NSInteger tempIntegerValue = (NSInteger)timeInterval;
                standTimeSpace = [NSString stringWithFormat:@"%lds",(long)tempIntegerValue];
            }
            
            if(standTimeSpace != nil)
                [endOfOneArray setValue:standTimeSpace forKey:@"localOp_standTime"];
        }
        else
        {
            NSMutableArray *oneArray = [retArray objectAtIndex:index];
            NSMutableDictionary *endOfOneArray = [oneArray lastObject];
            [endOfOneArray setValue:@"" forKey:@"localOp_standTime"];
        }
    }
    
    return retArray;;
}

@end
