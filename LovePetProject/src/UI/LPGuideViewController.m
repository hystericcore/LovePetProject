//
//  LPGuideViewController.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 15..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPGuideViewController.h"

#import "UIBarButtonItem+Utils.h"
#import "UIView+Utils.h"

NSUInteger const kLPGuidePageNumber = 3;

NSUInteger const kLPGuideBandHeight = 5;
NSUInteger const kLPGuidePageControlHeight = 60;
NSUInteger const kLPGuideBottomBarHeight = 44;

NSUInteger const kLPGuidePadding = 20;

@interface LPGuideViewController ()

@end

@implementation LPGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createGuideView];
    [self loadGuideView];
}

- (void)createGuideView
{
    CGRect frame = self.view.bounds;
    
    // create scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(frame) * kLPGuidePageNumber, CGRectGetHeight(frame))];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setDelegate:self];
    [self.view addSubview:_scrollView];
    
    // create band view;
    frame.size.height = kLPGuideBandHeight;
    UIView *bandView = [[UIView alloc] initWithFrame:frame];
    [bandView setBackgroundColor:COLOR_LOVEPET];
    [self.view addSubview:bandView];
    
    // create bottom bar
    frame.size.height = kLPGuideBottomBarHeight;
    frame.origin.y = CGRectGetHeight(_scrollView.frame) - kLPGuideBottomBarHeight;
    self.bottomBar = [[UIToolbar alloc] initWithFrame:frame];
    [_bottomBar setBackgroundImage:[UIImage imageNamed:@"navbar_background.png"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:_bottomBar];
    
    // create bottom bar items
    UIBarButtonItem *empty = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"시작하기" style:UIBarButtonItemStyleBordered target:self action:@selector(actionCloseButton:)];
    [closeButton setBlueAppearance];
    [_bottomBar setItems:@[empty, closeButton]];
    
    // create page control
    frame.size.height = kLPGuidePageControlHeight;
    frame.origin.y = CGRectGetHeight(_scrollView.frame) - kLPGuidePageControlHeight - kLPGuideBottomBarHeight;
    self.pageControl = [[UIPageControl alloc] initWithFrame:frame];
    [_pageControl setNumberOfPages:kLPGuidePageNumber];
    [_pageControl setPageIndicatorTintColor:COLOR_SINGLE_LINE_ALPHA3];
    [_pageControl setCurrentPageIndicatorTintColor:COLOR_LIGHT_TEXT];
    [_pageControl setUserInteractionEnabled:NO];
    [self.view addSubview:_pageControl];
}

- (void)loadGuideView
{
    [self addSubviewToScrollView:[self createFrontGuideView] atIndex:0];
    
    for (int i = 1; i < kLPGuidePageNumber; i++) {
        [self addSubviewToScrollView:[self createGuideViewAtIndex:i] atIndex:i];
    }
}

- (void)addSubviewToScrollView:(UIView *)subview atIndex:(NSUInteger)index
{
    CGFloat x = CGRectGetWidth(_scrollView.frame) * index;
    CGRect frame = subview.frame;
    frame.origin.x = x;
    [subview setFrame:frame];
    
    [_scrollView addSubview:subview];
}

- (UIView *)createFrontGuideView
{
    UIView *frontGuideView = [[UIView alloc] initWithFrame:_scrollView.frame];
    
    // logo
    UIImage *image = [UIImage imageNamed:@"lovepet_logo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = CGRectMake(75, 50, image.size.width / 2, image.size.height / 2);
    [imageView setFrame:frame];
    [frontGuideView addSubview:imageView];
    
    // line
    [frontGuideView drawLineFrom:CGPointMake(62.5f, 160) to:CGPointMake(257.5, 160) lineWidth:0.5f color:COLOR_SINGLE_LINE_ALPHA5 dotted:NO];
    
    UILabel *text1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 185, 320, 34)];
    [text1 setText:NSLocalizedString(@"LPGuideViewFrontText1", nil)];
    [text1 setFont:[UIFont systemFontOfSize:14]];
    [text1 setTextColor:COLOR_LIGHT_TEXT];
    [text1 setNumberOfLines:0];
    [text1 setTextAlignment:NSTextAlignmentCenter];
    [frontGuideView addSubview:text1];
    
    UILabel *text2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 252, 320, 51)];
    [text2 setText:NSLocalizedString(@"LPGuideViewFrontText2", nil)];
    [text2 setFont:[UIFont systemFontOfSize:14]];
    [text2 setTextColor:COLOR_TEXT];
    [text2 setNumberOfLines:0];
    [text2 setTextAlignment:NSTextAlignmentCenter];
    [frontGuideView addSubview:text2];
    
    return frontGuideView;
}

- (UIView *)createGuideViewAtIndex:(NSUInteger)index
{
    UIView *guideView = [[UIView alloc] initWithFrame:_scrollView.frame];
    
    NSString *titleKey = [NSString stringWithFormat:@"LPGuideViewTitle%d", index];
    NSString *imageKey = [NSString stringWithFormat:@"guide%d", index];
    NSString *textKey = [NSString stringWithFormat:@"LPGuideViewText%d", index];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLPGuidePadding, kLPGuideBandHeight + kLPGuidePadding, 320, 24)];
    [titleLabel setText:NSLocalizedString(titleKey, nil)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [titleLabel setTextColor:COLOR_TEXT];
    [guideView addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLPGuidePadding, CGRectGetMaxY(titleLabel.frame) + kLPGuidePadding, 320 - (kLPGuidePadding * 2), 165)];
    [imageView setImage:[UIImage imageNamed:imageKey]];
    [guideView addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLPGuidePadding, CGRectGetMaxY(imageView.frame) + kLPGuidePadding, 320 - (kLPGuidePadding * 2), 200)];
    [textLabel setText:NSLocalizedString(textKey, nil)];
    [textLabel setFont:[UIFont systemFontOfSize:14]];
    [textLabel setTextColor:COLOR_LIGHT_TEXT];
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    [guideView addSubview:textLabel];
    
    return guideView;
}

#pragma mark - Action methods

- (void)actionCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)actionLoginButton:(id)sender
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    NSUInteger pageNum = _scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
    [_pageControl setCurrentPage:pageNum];
}

@end
