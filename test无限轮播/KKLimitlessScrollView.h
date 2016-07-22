//
//  KKLimitlessScrollView.h
//  test无限轮播
//
//  Created by nice on 16/6/24.
//  Copyright © 2016年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Sizes.h"

@interface KKLimitlessScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageNameArray;
@property (nonatomic, assign) UIEdgeInsets pageEdgeInset;

@end
