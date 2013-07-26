//
//  LPPetDetailViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDetailViewController.h"
#import "LPPetDetailView.h"
#import "LPPetVO.h"

#import "UIImageView+AFNetworking.h"

@implementation LPPetDetailViewController

- (id)initWithPetVO:(LPPetVO *)petVO
{
    self = [super init];
    if (self) {
        self.petVO = petVO;
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
    
    [self loadDetailContents];
}

- (void)createShareButton
{
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareButton:)];
    [self.navigationItem setRightBarButtonItem:shareButtonItem];
}

- (void)actionShareButton:(UIBarButtonItem *)button
{
    NSArray *activityItems = @[@"당신이 사랑하고 싶은 반려동물의 이야기, 유기동물을 입양해보는건 어떠세요?", _petVO.image];
    
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

- (void)loadDetailContents
{
    if (_petVO.image) {
        [self loadComplete];
        return;
    }
    
    NSURL *imageURL = [NSURL URLWithString:_petVO.imageSrc];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    UIImage *(^imageProcessingBlock)() = ^UIImage *(UIImage *image) {
        return image;
    };
    void (^success)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _petVO.image = image;
        [self loadComplete];
    };
    void (^failure)() = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self loadFail];
    };
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:imageProcessingBlock success:success failure:failure];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
}

- (void)loadComplete
{
    LPPetDetailView *view = (LPPetDetailView *)self.view;
    view.photoView.image = _petVO.image;
    view.typeLabel.text = _petVO.petType;
    view.dayLabel.text = _petVO.leftDay;
    view.detailLabel.text = [NSString stringWithFormat:@"%@ / %@일 발견", _petVO.detail, _petVO.date];
}

- (void)loadFail
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"데이터를 가져오는데 실패했습니다!" delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil];
    [alert show];
}

@end
