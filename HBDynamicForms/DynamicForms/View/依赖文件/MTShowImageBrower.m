//
//  MTShowImageBrower.m
//  GDWWNOP
//
//  Created by QinJ on 2017/11/3.
//  Copyright © 2017年 cn.mastercom. All rights reserved.
//

#import "MTShowImageBrower.h"
#import "UIImageView+WebCache.h"

@interface MTShowImageBrower ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) NSArray *images;

@end

@implementation MTShowImageBrower

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alpha = 0;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scrollView];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tap];
    }
    return self;
}

- (void)layoutSubviews {
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    for (NSInteger i = 0; i < self.images.count; i++) {
        UIScrollView *subScrollView = (UIScrollView *)[self.scrollView viewWithTag:2000 + i];
        UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:1000 + i];
        if (imageView && subScrollView) {
            imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            subScrollView.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight);
            subScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        }
    }
}

- (void)showWithImages:(NSArray *)images index:(NSInteger)index {
    for (UIScrollView *scrollView in self.scrollView.subviews) {
        [scrollView removeFromSuperview];
    }
    self.images = images;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * images.count, kScreenHeight);
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:NO];
    
    NSInteger i = 0;
    for (id image in images) {
        UIScrollView *subScorllView = [UIScrollView new];
        subScorllView.tag = 2000 + i;
        subScorllView.maximumZoomScale = 3.f;
        subScorllView.minimumZoomScale = 1.f;
        subScorllView.delegate = self;
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 1000 + i;
        if ([image isKindOfClass:[UIImage class]]) {
            //直接显示
            imageView.image = (UIImage *)image;
        }
        else {
            
            NSString *url = [image containsString:@"http"]? image : [NSString stringWithFormat:@"http://%@/%@" ,kHostUrl, image];
            
            //需要下载
            //[imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic_thumb"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic_thumb"]];
        }
        [subScorllView addSubview:imageView];
        
        [self.scrollView addSubview:subScorllView];
        i++;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self show];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *imageView = nil;
    for (id subView in scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            imageView = subView;
            break;
        }
    }
    return imageView;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
    }];
}

- (void)close {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -getter
- (UIScrollView *)scrollView {
    if (nil == _scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UITapGestureRecognizer *)tap {
    if (nil == _tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    }
    return _tap;
}

@end
