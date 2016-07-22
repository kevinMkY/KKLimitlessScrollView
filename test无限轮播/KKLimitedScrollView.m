//
//  KKLimitedScrollView.m
//  test无限轮播
//
//  Created by nice on 16/6/28.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "KKLimitedScrollView.h"

static NSUInteger maxIndex = 10000;
static NSUInteger halfMaxIndex = 5000;
static NSString *const KKLimitedScrollCellID = @"KKLimitedScrollCellID";

@interface KKLimitedScrollCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation KKLimitedScrollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

@end

@interface KKLimitedScrollView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *moveTime;             //循环滚动的周期时间

@end

@implementation KKLimitedScrollView

- (void)dealloc
{
    NSLog(@"KKLimitedScrollView  销毁了");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.autoScrollTimerPadding = 1.0f;
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[KKLimitedScrollCell class] forCellWithReuseIdentifier:KKLimitedScrollCellID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setPageEdgeInset:(UIEdgeInsets)pageEdgeInset
{
    _pageEdgeInset = pageEdgeInset;
    self.layout.sectionInset = pageEdgeInset;
    [self reset];
}

- (void)setLinePading:(CGFloat)linePading
{
    _linePading = linePading;
    self.layout.minimumLineSpacing = linePading * 2;
    [self reset];
}

-(void)setInteritemSpacing:(CGFloat)interitemSpacing
{
    _interitemSpacing = interitemSpacing;
    self.layout.minimumInteritemSpacing = interitemSpacing * 2;
    [self reset];
}

- (void)setImageNameArray:(NSArray *)imageNameArray
{
    _imageNameArray = imageNameArray;
    [self reset];
}

- (void)reset
{
    [self.collectionView reloadData];
    
    NSUInteger index = halfMaxIndex - (halfMaxIndex % _imageNameArray.count) + self.defaultIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    [self startScroll];
}

#pragma mark - delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.cg_width - self.pageEdgeInset.left - self.pageEdgeInset.right;
    CGFloat height = collectionView.cg_height - self.pageEdgeInset.top - self.pageEdgeInset.bottom;
    return CGSizeMake(width, height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return maxIndex;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKLimitedScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KKLimitedScrollCellID forIndexPath:indexPath];
    NSUInteger count = indexPath.row%self.imageNameArray.count;
    NSString *imageName;
    if (count < self.imageNameArray.count) {
        imageName = self.imageNameArray[count];
    }else{
        imageName = @"";
    }
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTime];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self invalidateTime];
    [self resetTimer];
}

#pragma mark - timer

- (void)setAutoScrollTimerPadding:(CGFloat)autoScrollTimerPadding
{
    _autoScrollTimerPadding = autoScrollTimerPadding;
    [self resetTimer];
}

- (NSTimer *)moveTime
{
    if (!_moveTime) {
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimerPadding target:self selector:@selector(animationMoveImage) userInfo:nil repeats:YES];
    }
    return _moveTime;
}

- (void)animationMoveImage
{
    CGPoint center = CGPointMake(CGRectGetMidX(_collectionView.bounds), CGRectGetMidY(_collectionView.bounds));
    NSIndexPath *path = [_collectionView indexPathForItemAtPoint:center];
    if (!path) {
        return;
    }
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:path];
    if (!cell) {
        return;
    }
    
    if (path.item < maxIndex - 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:path.item + 1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
}

- (void)resetTimer
{
    [self invalidateTime];
    [[NSRunLoop mainRunLoop] addTimer:self.moveTime forMode:NSRunLoopCommonModes];
    
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
    [self resetTimer];
}

@end
