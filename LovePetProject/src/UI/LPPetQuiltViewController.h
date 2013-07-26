//
//  LPPetListViewController.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 6..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "TMQuiltViewController.h"
@class ISRefreshControl, LPPetDAO;
@interface LPPetQuiltViewController : TMQuiltViewController <UIActionSheetDelegate>
- (id)initWithPetDAO:(LPPetDAO *)petDAO;
@property (nonatomic, strong) NSArray *petDataSource;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) ISRefreshControl *refreshControl;
@property (nonatomic, strong) LPPetDAO *petDAO;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end
