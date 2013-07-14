//
//  LPPetDetailViewController.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPetVO;

@interface LPPetDetailViewController : UIViewController
@property (nonatomic, strong) LPPetVO *petVO;
- (void)createPetDetailData:(LPPetVO *)petVO;
@end
