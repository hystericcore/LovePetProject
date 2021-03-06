//
//  LPPetListViewController.h
//  LovePetProject
//
//  Created by NTS Mobile on 13. 7. 27..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"

@class ISRefreshControl;
@protocol LPPetDAO;
@interface LPPetListViewController : UIViewController <PSCollectionViewDataSource, PSCollectionViewDelegate, UIScrollViewDelegate>
- (id)initWithDAO:(id<LPPetDAO>)dao;
@property (nonatomic, assign) id<LPPetDAO> petDAO;
@property (nonatomic, strong) PSCollectionView *petListView;
@property (nonatomic, strong) NSArray *petDataSource;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) ISRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSMutableArray *petShowed;
@end
