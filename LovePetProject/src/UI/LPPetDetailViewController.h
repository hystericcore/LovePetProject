//
//  LPPetDetailViewController.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPPetVO, UIImageViewModeScaleAspect;
@interface LPPetDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
- (id)initWithPetVO:(LPPetVO *)petVO;
@property (nonatomic, strong) LPPetVO *petVO;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageViewModeScaleAspect *headerView;
@property (nonatomic, strong) NSString *shortenLinkSrc;
@end
