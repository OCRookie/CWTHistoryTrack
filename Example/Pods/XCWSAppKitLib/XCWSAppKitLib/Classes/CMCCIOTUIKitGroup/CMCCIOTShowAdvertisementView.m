//
//  CMCCIOTShowAdvertisementView.m
//  AdvertisementScroll
//
//  Created by yue wang on 15/9/7.
//  Copyright (c) 2015年 cmcc. All rights reserved.
//

#import "CMCCIOTShowAdvertisementView.h"
#import "UIImageView+WebCache.h"
#define w self.bounds.size.width
#define h self.bounds.size.height
#define timeInterval 5.0
@interface CMCCIOTShowAdvertisementView ()<UIScrollViewDelegate>
{
    UIScrollView *_mainScrollView;
    UIPageControl *_pageCountrol;
    NSTimer *_timer;
    BOOL _draging;//标记是否drag
}
@end

@implementation CMCCIOTShowAdvertisementView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
    [self invalidateTimer];
}
-(void)invalidateTimer
{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _draging = NO;
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _mainScrollView.contentInset = UIEdgeInsetsMake(0, w, 0, w);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        [self addSubview:_mainScrollView];
        
        _pageCountrol = [[UIPageControl alloc]initWithFrame:CGRectMake((w-100)/2, h-40, 100, 20)];
        [self addSubview:_pageCountrol];
        
    }
    return self;
}

-(void)setImageURLArray:(NSArray *)imageURLArray
{
    _imageURLArray = imageURLArray;
    
    for (UIView *view in _mainScrollView.subviews) {
        if ([view isMemberOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (_imageURLArray.count > 0) {
        _pageCountrol.numberOfPages = _imageURLArray.count;
        
        [self addImageViewWithIndex:-1 urlStrIndex:(int)_imageURLArray.count-1];
        
        for (int i=0; i<_imageURLArray.count; i++) {
            [self addImageViewWithIndex:i urlStrIndex:i];
        }
        
        [self addImageViewWithIndex:(int)_imageURLArray.count urlStrIndex:0];
    }
    _mainScrollView.contentSize = CGSizeMake(_imageURLArray.count*w, h);
    
    
    //添加定时器
    [self performSelector:@selector(delayTimer) withObject:nil afterDelay:timeInterval];
    
}
//延时timeInterval后添加定时器
-(void)delayTimer
{
    [self invalidateTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];
    [_timer fire];
}
//添加imageView到scrollView上的方法 i:offSetX的基数  index：取图片imageURLArray里的哪一张
-(void)addImageViewWithIndex:(int)i urlStrIndex:(int)index
{
    UIImageView *aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*w, 0, w, h)];
    aImageView.userInteractionEnabled = YES;
    aImageView.tag = index;
    [aImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[index]]];
   // [aImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[index]] placeholderImage:[UIImage imageNamed:@"laptopBackground.png"]];
    [_mainScrollView addSubview:aImageView];
    
    //手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [aImageView addGestureRecognizer:gesture];
}

//手势点击事件
-(void)tapImage:(UITapGestureRecognizer *)gesture
{
    NSInteger tag =  gesture.view.tag;
    if (_delegate &&[_delegate respondsToSelector:@selector(loopCurrentIndex:)])
        [_delegate loopCurrentIndex:tag];
}


#pragma mark - timer
-(void)timerLoop
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint aContentOffset = _mainScrollView.contentOffset;
        aContentOffset.x += w;
        _mainScrollView.contentOffset = aContentOffset;
    } completion:^(BOOL finished) {
        CGPoint aContentOffset = _mainScrollView.contentOffset;
        int tag = (int)aContentOffset.x/w;
        if (tag == _imageURLArray.count) {
            
            aContentOffset.x = 0;
            _mainScrollView.contentOffset = aContentOffset;
        }
        _pageCountrol.currentPage = tag%_imageURLArray.count;
    }];
}

#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_draging) {     //drag时有效，不drag无效，定时器的方法timerLoop不受下面代码影响
        
        CGPoint contentOffset = scrollView.contentOffset;
        if (contentOffset.x == w*_imageURLArray.count) {
            _pageCountrol.currentPage = 0;
            contentOffset.x = 0;
            scrollView.contentOffset = contentOffset;
        }
        else if(contentOffset.x == -w){
            _pageCountrol.currentPage = _imageURLArray.count-1;
            contentOffset.x = (_imageURLArray.count-1)*w;
            scrollView.contentOffset = contentOffset;
        }
        else{
            _pageCountrol.currentPage = (int)contentOffset.x/w;
        }
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer setFireDate:[NSDate distantFuture]];//当手动滑动图片时，让定时器挂起
    _draging = YES;//标记正在drag
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _draging = NO;//标记drag结束
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];//当手动滑动结束图片停止运动时，重启定时器
}


@end
