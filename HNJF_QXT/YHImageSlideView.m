//
//  YHImageSlideView.m
//  YHImageSlideView
//
//  Created by 江伟 on 15/12/18.
//  Copyright © 2015年 jiangw. All rights reserved.
//

#import "YHImageSlideView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface YHImageSlideView()

@property(nonatomic, strong) UIScrollView *imageScroll;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property(nonatomic, weak) NSTimer *timer;

@end

@implementation YHImageSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageScroll];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews {
    if (self.imageViews.count > 1 && !CGSizeEqualToSize(self.imageScroll.contentSize, CGSizeZero)) {
        UIImageView *firstImage = self.imageViews[1];
//        NSLog(@"image frame: %@", NSStringFromCGRect(firstImage.frame));
        self.imageScroll.contentOffset = firstImage.frame.origin;
    }
}

- (void)updateConstraints {
    [self.imageScroll mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-6);
        make.height.mas_offset(20);
    }];
    
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imgView = self.imageViews[i];
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.imageScroll);
            make.top.bottom.equalTo(self.imageScroll);
            
            if (i == 0) {
                make.left.equalTo(self.imageScroll);
            }
            else {
                UIImageView *pervImgView = self.imageViews[i - 1];
                make.left.equalTo(pervImgView.mas_right);
            }
            
            if (i == self.imageViews.count - 1) {
                make.right.equalTo(self.imageScroll);
            }
        }];
    }
    
    [super updateConstraints];
}


#pragma mark - private

- (void)clearAllImages {
    for (UIImageView *view in self.imageViews) {
        [view removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
}

- (void)revolvingScroll {
    if (self.imgUrls.count > 1) {
        CGFloat pageWidth = CGRectGetWidth(self.imageScroll.frame);
        CGPoint lastImageOffset = CGPointMake(pageWidth * (self.imageViews.count - 2), 0);
        if (CGPointEqualToPoint(self.imageScroll.contentOffset, lastImageOffset)) {
            self.imageScroll.contentOffset = CGPointMake(0, 0);
        }
        [self.imageScroll setContentOffset:CGPointMake(self.imageScroll.contentOffset.x + pageWidth, 0) animated:YES];
        
        if(self.pageControl.currentPage < self.pageControl.numberOfPages - 1) {
            self.pageControl.currentPage++;
        }
        else {
            self.pageControl.currentPage = 0;
        }
    }
}


#pragma mark - property

- (UIScrollView *)imageScroll {
    if (!_imageScroll) {
        _imageScroll = [[UIScrollView alloc] init];
        _imageScroll.showsHorizontalScrollIndicator = NO;
        _imageScroll.showsVerticalScrollIndicator = NO;
        _imageScroll.pagingEnabled = YES;
        _imageScroll.bounces = NO;
        _imageScroll.delegate = self;
        
        _imageScroll.backgroundColor = [UIColor lightGrayColor];
//        _imageScroll.clipsToBounds = NO;
    }
    return _imageScroll;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (void)setImgUrls:(NSArray<NSString *> *)urls {
    if (_imgUrls != urls) {
        if (self.timer) {
            [self.timer invalidate];
        }
        
        _imgUrls = urls;
        self.pageControl.numberOfPages = urls.count;
        self.pageControl.currentPage = 0;
        [self clearAllImages];
        
        [_imgUrls enumerateObjectsUsingBlock:^(id url, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            [self.imageViews addObject:imageView];
            [self.imageScroll addSubview:imageView];
        }];
        
        if (_imgUrls.count > 1) {
            UIImageView *leading = [[UIImageView alloc] init];
            [leading sd_setImageWithURL:[NSURL URLWithString:[_imgUrls lastObject]]];
            [self.imageViews insertObject:leading atIndex:0];
            [self.imageScroll addSubview:leading];
            
            UIImageView *trailing = [[UIImageView alloc] init];
            [trailing sd_setImageWithURL:[NSURL URLWithString:[_imgUrls firstObject]]];
            [self.imageViews addObject:trailing];
            [self.imageScroll addSubview:trailing];
            
            self.pageControl.hidden = NO;
        }
        else {
            self.pageControl.hidden = YES;
        }
        
        [self setNeedsUpdateConstraints];
        
        self.timer = [NSTimer
                      scheduledTimerWithTimeInterval:5
                      target:self
                      selector:@selector(revolvingScroll) userInfo:nil repeats:YES];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.imageScroll.frame);
    CGPoint firstImageOffset = CGPointMake(0, 0);
    CGPoint lastImageOffset = CGPointMake(pageWidth * (self.imageViews.count - 1), 0);
    if (CGPointEqualToPoint(self.imageScroll.contentOffset, lastImageOffset)) {
        self.imageScroll.contentOffset = CGPointMake(firstImageOffset.x + pageWidth, 0);
    }
    if (CGPointEqualToPoint(self.imageScroll.contentOffset, firstImageOffset)) {
        self.imageScroll.contentOffset = CGPointMake(lastImageOffset.x - pageWidth, 0);
    }
    
    if (CGPointEqualToPoint(self.imageScroll.contentOffset, CGPointMake(0, 0))) {
        self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
    }
    else if (CGPointEqualToPoint(self.imageScroll.contentOffset, CGPointMake(pageWidth * (self.imageViews.count - 1), 0))) {
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = ceil(self.imageScroll.contentOffset.x / pageWidth) - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:5
                  target:self
                  selector:@selector(revolvingScroll) userInfo:nil repeats:YES];
}

@end
