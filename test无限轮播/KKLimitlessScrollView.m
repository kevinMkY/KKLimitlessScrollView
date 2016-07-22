//
//  KKLimitlessScrollView.m
//  test无限轮播
//
//  Created by nice on 16/6/24.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "KKLimitlessScrollView.h"

static CGFloat const chageImageTime = 1.0;
static NSUInteger currentImage = 1;//记录中间图片的下标,开始总是为1

//#define KKLimitlessScrollViewContentMode UIViewContentModeScaleAspectFit

@interface KKLimitlessContentPageView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) UIEdgeInsets pageEdgeInset;
@property (nonatomic, strong) UIImageView *imgContentView;

@end

@implementation KKLimitlessContentPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imgContentView];
    }
    return self;
}

- (UIImageView *)imgContentView
{
    if (!_imgContentView) {
        _imgContentView = [[UIImageView alloc] initWithFrame:[self pageFrame]];
        _imgContentView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imgContentView;
}

- (void)setPageEdgeInset:(UIEdgeInsets)pageEdgeInset
{
    _pageEdgeInset = pageEdgeInset;
    self.imgContentView.frame = [self pageFrame];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imgContentView.image = image;
}

- (CGRect)pageFrame
{
    CGFloat x = _pageEdgeInset.left;
    CGFloat y = _pageEdgeInset.top;
    CGFloat w = self.cg_width - x - _pageEdgeInset.right;
    CGFloat h = self.cg_height - y - _pageEdgeInset.bottom;
    
    return CGRectMake(x, y, w, h);
}

@end

@interface KKLimitlessScrollView ()
{
    BOOL _isTimeUp;     //是否是定时器滚动行为
}

@property (nonatomic, strong)   KKLimitlessContentPageView *leftImageView;
@property (nonatomic, strong)   KKLimitlessContentPageView *centerImageView;
@property (nonatomic, strong)   KKLimitlessContentPageView *rightImageView;
@property (nonatomic, strong)   NSTimer     *moveTime;             //循环滚动的周期时间

@end

@implementation KKLimitlessScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentSize = CGSizeMake([self pageWidth] * 3, [self pageHeight]);
        self.contentOffset = CGPointMake([self pageWidth], 0);
        self.delegate = self;
    
        [self createUI];
        [self configX];
        [self startScroll];
    }
    return self;
}

- (void)createUI
{
    [self addSubview:self.leftImageView];
    [self addSubview:self.centerImageView];
    [self addSubview:self.rightImageView];
}

- (KKLimitlessContentPageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[KKLimitlessContentPageView alloc] initWithFrame:self.bounds];
    }
    return _leftImageView;
}

- (KKLimitlessContentPageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[KKLimitlessContentPageView alloc] initWithFrame:self.bounds];
    }
    return _centerImageView;
}

- (KKLimitlessContentPageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[KKLimitlessContentPageView alloc] initWithFrame:self.bounds];
    }
    return _rightImageView;
}

#pragma mark - methods

- (void)setImageNameArray:(NSArray *)imageNameArray
{
    _imageNameArray = imageNameArray;
    currentImage = 1;
    [self configImage];
}

- (void)setPageEdgeInset:(UIEdgeInsets)pageEdgeInset
{
    _pageEdgeInset = pageEdgeInset;
    self.leftImageView.pageEdgeInset   = pageEdgeInset;
    self.centerImageView.pageEdgeInset = pageEdgeInset;
    self.rightImageView.pageEdgeInset  = pageEdgeInset;
}

- (void)configImage
{
    self.leftImageView.image   = [UIImage imageNamed:_imageNameArray[(currentImage -1)%_imageNameArray.count]];
    self.centerImageView.image = [UIImage imageNamed:_imageNameArray[currentImage % _imageNameArray.count]];
    self.rightImageView.image  = [UIImage imageNamed:_imageNameArray[(currentImage +1)%_imageNameArray.count]];
}

- (void)configX
{
    self.leftImageView.cg_left   = [self pageWidth] * 0;
    self.centerImageView.cg_left = [self pageWidth] * 1;
    self.rightImageView.cg_left  = [self pageWidth] * 2;
}

#pragma mark - timer

- (NSTimer *)moveTime
{
    if (!_moveTime) {
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_moveTime forMode:NSRunLoopCommonModes];
//        _isTimeUp = NO;
    }
    return _moveTime;
}

- (void)animalMoveImage
{
    currentImage = (currentImage + 1)%_imageNameArray.count;
    
    NSLog(@"current  %zd",currentImage);
    
    [self setContentOffset:CGPointMake(2 * [self pageWidth], 0) animated:YES];
}

- (void)resetTimer
{
    [self invalidateTime];
    [self.moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    
    NSLog(@"fire");
}

- (void)invalidateTime
{
    if (_moveTime) {
        [_moveTime invalidate];
        _moveTime = nil;
        
        NSLog(@"invalidate");
    }
}

- (void)startScroll
{
//    _isTimeUp = YES;
    [self resetTimer];
}

#pragma mark - delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"end scroll   %zd     %@",currentImage,NSStringFromCGPoint(self.contentOffset));
    self.contentOffset = CGPointMake([self pageWidth], 0);
    [self configImage];
    [self resetTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTime];
//    _isTimeUp = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self invalidateTime];
    [self resetTimer];
}

#pragma mark - frame

- (CGFloat)pageWidth
{
    return self.cg_width;
}

- (CGFloat)pageHeight
{
    return self.cg_height;
}

@end
