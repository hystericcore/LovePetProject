//
//  LPPetTypeViewController.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 24..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const kLPSearchOptionPetType;
extern NSString * const kLPSearchOptionLocation;
@interface LPSearchOptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *searchOption;
@end
