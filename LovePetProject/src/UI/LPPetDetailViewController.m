//
//  LPPetDetailViewController.m
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPPetDetailViewController.h"
#import "LPPetDetailView.h"

#import "HTMLParser.h"
#import "HTMLNode.h"

#import "LPPetVO.h"

@implementation LPPetDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        
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
//    UIImage *shareImage = [UIImage imageNamed:@"nav_button_sendto@2x.png"];
//    UIButton *shareButton = [[UIButton alloc] init];
//    [shareButton setImage:shareImage forState:UIControlStateNormal];
//    [shareButton addTarget:self action:@selector(actionShareButton:) forControlEvents:UIControlEventTouchUpInside];
//    [shareButton setFrame:CGRectMake(0, 0, 40, 30)];
//    
//    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
//    [shareButton release];
    
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

- (void)createPetDetailData:(LPPetVO *)petVO
{
    /*
    NSString *html = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:petVO.linkSrc]
                                                    encoding:NSEUCKRStringEncoding
                                                       error:nil];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:nil];
    HTMLNode *bodyNode = [parser body];
    
    // Image
    HTMLNode *imageNode = [bodyNode findChildOfClass:@"photoArea"];
    petVO.imageSrc = [NSString stringWithFormat:@"%@%@", kLPPetDataDomain, [imageNode getAttributeNamed:@"src"]];
    
    // Telephone
    HTMLNode *viewTableNode = [bodyNode findChildOfClass:@"viewTable"];
    NSArray *trNodes = [viewTableNode findChildTags:@"tr"];
    HTMLNode *trNode = [trNodes objectAtIndex:trNodes.count - 2];
    NSArray *tdNodes = [trNode findChildTags:@"td"];
    HTMLNode *telNode = [tdNodes objectAtIndex:1];
    petVO.tel = [telNode contents];
    
    self.petVO = petVO;
    
    [self loadPetDetailData];
     */
}

- (void)loadPetDetailData
{
    /*
    [WebImageOperations processImageDataWithURLString:_petVO.imageSrc andBlock:^(NSData *imageData) {
        if (self.view.window) {
            UIImage *image = [UIImage imageWithData:imageData];
            _petVO.image = image;
            
            [self loadComplete];
        }
    }];
     */
}

- (void)loadComplete
{
    LPPetDetailView *view = (LPPetDetailView *)self.view;
    view.photoView.image = _petVO.image;
    view.typeLabel.text = _petVO.type;
    view.dayLabel.text = _petVO.leftDay;
    view.detailLabel.text = [NSString stringWithFormat:@"%@ / %@일 발견", _petVO.detail, _petVO.date];
}

@end
