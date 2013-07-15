//
//  LPPetDetailViewController.h
//  LovePetProject
//
//  Created by HyunJoon Park on 13. 7. 7..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPPetDAO, LPPetVO;
@interface LPPetDetailViewController : UIViewController {
    NSUInteger _petIndex;
}
- (id)initWithPetDAO:(LPPetDAO *)petDAO;
@property (nonatomic, strong) LPPetDAO *petDAO;
@property (nonatomic, strong) LPPetVO *petVO;
- (void)loadPetDataAtIndex:(NSInteger)index;
@end
