//
//  LPGuideViewController.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 15..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPGuideViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIToolbar *bottomBar;
@end
