# KKLimitlessScrollView
利用collectionview做有边距的无限轮播

# 预览图


# 用法

```
KKLimitedScrollView *scrollView = [[KKLimitedScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
scrollView.imageNameArray = @[@"image0",@"image1",@"image2",@"image3"];
scrollView.pageEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10);
scrollView.linePading = 10;
scrollView.interitemSpacing = 10;
scrollView.autoScrollTimerPadding = 1.5f;
[self.view addSubview:scrollView];
```
