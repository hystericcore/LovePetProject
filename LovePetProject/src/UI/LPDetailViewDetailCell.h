//
//  LPDetailViewCell.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 31..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPDetailCellDefine.h"

#define LPDetailViewDetailCellHeight kCellHeaderMargin + kCellHeaderHeight + kCellHeight * kDetailCellNumber + kCellFooterHeight + kCellMargin

@interface LPDetailViewDetailCell : UITableViewCell <UIAlertViewDelegate>
- (void)setDetailContentLabelsText:(NSArray *)texts;
@end
