//
//  LPLeftListViewController.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPLeftViewController : UITableViewController
@property (nonatomic, strong) NSArray *controllerNames;
@property (nonatomic, strong) NSMutableDictionary *controllerList;

@property (nonatomic, assign) NSInteger selectedIndex;
@end