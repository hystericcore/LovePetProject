//
//  UIViewController+Commons.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 8. 1..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Commons)
- (void)createNavTitleView;
- (void)createLeftViewButton;
- (void)createBackButton;
- (UIBarButtonItem *)createBarButtomItemToTarget:(id)target action:(SEL)selector imageName:(NSString *)imageName;
@end
