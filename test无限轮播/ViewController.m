//
//  ViewController.m
//  test无限轮播
//
//  Created by nice on 16/6/24.
//  Copyright © 2016年 kk. All rights reserved.
//

#import "ViewController.h"
#import "KKLimitlessScrollView.h"
#import "KKLimitedScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self createScrollView];
    
}

- (void)createScrollView
{
    KKLimitedScrollView *scrollView = [[KKLimitedScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
    scrollView.imageNameArray = @[@"image0",@"image1",@"image2",@"image3"];
    scrollView.pageEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10);
    scrollView.linePading = 10;
    scrollView.interitemSpacing = 10;
    scrollView.autoScrollTimerPadding = 1.5f;
    [self.view addSubview:scrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
