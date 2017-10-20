//
//  CMCCIOTShowAdvertisementView.h
//  AdvertisementScroll
//
//  Created by yue wang on 15/9/7.
//  Copyright (c) 2015年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoopImageScrollViewDelegate <NSObject>

-(void)loopCurrentIndex:(NSInteger)index;

@end

@interface CMCCIOTShowAdvertisementView : UIView

@property (nonatomic,assign) id<LoopImageScrollViewDelegate> delegate;

@property (nonatomic,retain)NSArray *imageURLArray;

@end


