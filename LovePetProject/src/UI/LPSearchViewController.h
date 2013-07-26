//
//  LPSearchViewController.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 16..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPPetDAO;
extern NSString * const kLPNotificationSearchViewDismiss;
extern NSInteger const kLPSearchViewCellHeight;
extern NSInteger const kLPSearchViewHeight;
@interface LPSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (id)initWithPetDAO:(LPPetDAO *)petDAO;
@property (nonatomic, strong) LPPetDAO *petDAO;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *dismissKeyboardButton;
@end
