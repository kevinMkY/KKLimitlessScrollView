//
//  KKLimitedScrollView.h
//  test无限轮播
//
//  Created by nice on 16/6/28.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Sizes.h"

@interface KKLimitedScrollView : UIView

@property (nonatomic, strong) NSArray<NSString *> *imageNameArray;
@property (nonatomic, assign) UIEdgeInsets pageEdgeInset;
@property (nonatomic, assign) CGFloat linePading;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) NSUInteger defaultIndex;
@property (nonatomic, assign) CGFloat autoScrollTimerPadding;

@end
