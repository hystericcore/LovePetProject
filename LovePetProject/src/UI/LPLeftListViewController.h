//
//  LPLeftListViewController.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LPLeftListViewControllerDelegate;

@interface LPLeftListViewController : UITableViewController
@property (nonatomic, assign) id <LPLeftListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *listDataArray;
@end

@protocol LPLeftListViewControllerDelegate <NSObject>
- (void)leftListViewController:(LPLeftListViewController *)viewController didSelectListAtIndex:(NSInteger)index;
@end