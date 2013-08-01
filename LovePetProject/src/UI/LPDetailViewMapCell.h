//
//  LPDetailViewMapCell.h
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 31..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPDetailCellDefine.h"

#define LPDetailViewMapCellHeight kCellHeaderHeight + kMapTopMargin + kMapHeight + kCellFooterHeight + kCellMargin

@interface LPDetailViewMapCell : UITableViewCell <UIAlertViewDelegate>
- (void)setCenterLocation:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude;
@end
