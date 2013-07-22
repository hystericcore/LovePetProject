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
- (id)initWithPetVO:(LPPetVO *)petVO;
@property (nonatomic, strong) LPPetVO *petVO;
@end
