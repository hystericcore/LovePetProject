//
//  LPPetDetailViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDetailViewController.h"
#import "LPPetDetailView.h"

#import "LPPetDAO.h"
#import "LPPetVO.h"
#import "LPPetDetailVO.h"

@implementation LPPetDetailViewController

- (id)initWithPetDAO:(LPPetDAO *)petDAO
{
    self = [super init];
    if (self) {
        self.petDAO = petDAO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListUpdateComplete:) name:kLPNotificationPetListUpdateComplete object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListUpdateFail:) name:kLPNotificationPetListUpdateFail object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petListRequestFail:) name:kLPNotificationPetListRequestFail object:nil];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[LPPetDetailView alloc] init];
    self.view = view;
    [view sizeToFit];
    [view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createShareButton];
    [self createTitleImageView];
}

- (void)createShareButton
{
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareButton:)];
    [self.navigationItem setRightBarButtonItem:shareButtonItem];
}

- (void)actionShareButton:(UIBarButtonItem *)button
{
    NSArray *activityItems = @[@"당신이 사랑하고 싶은 반려동물의 이야기, 유기동물을 입양해보는건 어떠세요?", _petVO.detailVO.image];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                     applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)createTitleImageView
{
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_lovepet.png"]];
    [self.navigationItem setTitleView:titleView];
}

- (void)loadPetDataAtIndex:(NSInteger)index
{
    _petIndex = index;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadComplete) name:kLPNotificationPetDetailRequestComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFail) name:kLPNotificationPetDetailRequestFail object:nil];
    [_petDAO requestPetDetailDataAtIndex:index];
}

- (void)loadComplete
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.petVO = [_petDAO getPetDetailDataAtIndex:_petIndex];
    LPPetDetailView *view = (LPPetDetailView *)self.view;
    view.photoView.image = _petVO.detailVO.image;
    view.typeLabel.text = _petVO.detailVO.type;
    view.dayLabel.text = _petVO.leftDay;
    view.detailLabel.text = [NSString stringWithFormat:@"%@ / %@일 발견", _petVO.detailVO.detail, _petVO.detailVO.date];
}

- (void)loadFail
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"데이터를 가져오는데 실패했습니다!" delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
    [alert show];
}

@end
