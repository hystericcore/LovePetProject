//
//  LPPetTypeViewController.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 24..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LPSearchOptionViewControllerDelegate;
@interface LPSearchOptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id <LPSearchOptionViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger searchOption;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@protocol LPSearchOptionViewControllerDelegate <NSObject>
- (void)searchOptionViewController:(LPSearchOptionViewController *)controller didSelectOption:(NSInteger)index;
@end