//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#import <QuartzCore/QuartzCore.h>
#import "UIView+Sizes.h"

@implementation UIView (Sizes)

inline CGFloat KKConvertWidthForDeviceScale(CGFloat width)
{
    static CGFloat scale = 0;
    if (scale < 1) {
        scale = kScreenWidth / 320.0;
    }
    return ceilf(scale * width);
}

inline CGFloat KKConvertWidthForIp6Scale(CGFloat width)
{
    static CGFloat scaleIP6 = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scaleIP6 = kScreenWidth / 375.0;
    });
    
    return scaleIP6 * width;
}

inline CGFloat KKConvertWidthForIp6sScale(CGFloat width)
{
    static CGFloat screenScale = 0;
    
    static dispatch_once_t sreenOnceToken;
    dispatch_once(&sreenOnceToken, ^{
        screenScale = MAX(1, kScreenWidth / 375.0) ;
    });
    
    return ceil(screenScale * width);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_left {
	return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_left:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_top {
	return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_top:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_right {
	return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_right:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_bottom {
	return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_bottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_centerX {
	return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_centerX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_centerY {
	return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_centerY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_width {
	return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_width:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_height {
	return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_height:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_ttScreenX {
	CGFloat x = 0;
	for (UIView* view = self; view; view = view.superview) {
		x += [view cg_left];
	}
	return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_ttScreenY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += [view cg_top];
	}
	return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_screenViewX {
	CGFloat x = 0;
	for (UIView* view = self; view; view = view.superview) {
		x += [view cg_left];
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			x -= scrollView.contentOffset.x;
		}
	}
	
	return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cg_screenViewY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += [view cg_top];
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			y -= scrollView.contentOffset.y;
		}
	}
	return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)cg_screenFrame {
	return CGRectMake([self cg_screenViewX], [self cg_screenViewY], [self cg_width], [self cg_height]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)cg_origin {
	return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_origin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)cg_size {
	return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCg_size:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls])
		return self;
	
	for (UIView* child in self.subviews) {
		UIView* it = [child descendantOrSelfWithClass:cls];
		if (it)
			return it;
	}
	
	return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
	} else if (self.superview) {
		return [self.superview ancestorOrSelfWithClass:cls];
	} else {
		return nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
	CGFloat x = 0, y = 0;
	for (UIView* view = self; view && view != otherView; view = view.superview) {
		x += [view cg_left];
		y += [view cg_top];
	}
	return CGPointMake(x, y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}

- (UIImage *)imageFromView
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageFromViewByiOS7NewApi {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageFromViewWithLowResolution
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.5);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageFromViewInRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIView *)snapshotViewInRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x,-rect.origin.y);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    return [[UIImageView alloc] initWithImage:image];
}

- (CGRect)convertFrameToWindow:(UIWindow *)window
{   
    UIView *superView = [self superview];;
    
    CGRect frameInSuperView = [self frame];
    while (superView && (superView != window)){
        if ([superView superview])
        {
            frameInSuperView = [superView.superview convertRect:frameInSuperView fromView:superView];
        }
        superView = [superView superview];
    }
    return frameInSuperView;
}

- (CGRect)expandedFrame:(CGRect)originalFrame withOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, -offset, -offset);
}

- (CGRect)expandedFrame:(CGRect)originalFrame withVerticalOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, 0, -offset);
}

- (CGRect)expandedFrame:(CGRect)originalFrame withHorizontalOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, -offset, 0);
}

@end
