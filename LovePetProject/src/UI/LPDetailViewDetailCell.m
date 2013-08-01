//
//  LPDetailViewCell.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 31..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPDetailViewDetailCell.h"
#import "UIView+Utils.h"
#import "UILabel+Utils.h"

@interface LPDetailViewDetailCell ()
@property (nonatomic, strong) UIView *contentBaseView;
@property (nonatomic, strong) NSMutableArray *detailContentLabels;
@end

@implementation LPDetailViewDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:COLOR_GRAYWHITE];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self createContentBaseView];
        [self createHeaderView];
        [self createContentView];
    }
    return self;
}

- (void)createContentBaseView
{
    CGFloat contentBaseViewWidth = CGRectGetWidth(self.frame) - kCellMargin * 2;
    CGFloat contentBaseViewHeight = LPDetailViewDetailCellHeight - kCellHeaderMargin - kCellMargin;
    
    self.contentBaseView = [[UIView alloc] initWithFrame:CGRectMake(kCellMargin, kCellHeaderMargin,
                                                                    contentBaseViewWidth, contentBaseViewHeight)];
    [_contentBaseView setBoxShadow:YES];
    [_contentBaseView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_contentBaseView];
    
    [_contentBaseView drawLineFrom:CGPointMake(kCellContentLeftRightMargin, kCellHeaderHeight)
                                to:CGPointMake(contentBaseViewWidth - kCellContentLeftRightMargin, kCellHeaderHeight)
                         lineWidth:1
                             color:COLOR_SINGLE_LINE_ALPHA3
                            dotted:NO];
}

- (void)createHeaderView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellContentLeftRightMargin, 0, CGRectGetWidth(_contentBaseView.frame) - kCellContentLeftRightMargin * 2, kCellHeaderHeight)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setTextColor:COLOR_TEXT];
    [titleLabel setText:@"세부사항"];
    
    [_contentBaseView addSubview:titleLabel];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"petdetail_detail.png"]];
    CGRect titleImageFrame = CGRectMake(0, 0, 15, 15);
    titleImageFrame.origin.x = CGRectGetWidth(_contentBaseView.frame) - kCellContentLeftRightMargin - kCellContentLeftRightPadding - titleImageFrame.size.width;
    titleImageFrame.origin.y = titleLabel.center.y - titleImageFrame.size.height / 2;
    [titleImageView setFrame:titleImageFrame];
    
    [_contentBaseView addSubview:titleImageView];
}

- (void)createContentView
{
    NSArray *detailList = @[@"성별", @"나이", @"체중", @"접수일시", @"발견장소", @"공고번호", @"보호소", @"위치", @"연락처"];
    self.detailContentLabels = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat contentBaseViewWidth = CGRectGetWidth(self.frame) - kCellMargin * 2;
    
    CGFloat detailListY = kCellHeaderHeight;
    CGFloat detailTitleX = kCellContentLeftRightMargin + kCellContentLeftRightPadding;
    CGFloat detailTitleWidth = 55;
    CGFloat detailContentX = detailTitleX + detailTitleWidth;
    CGFloat detailContentWidth = 276 - 55;
    
    for (NSString *title in detailList) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailTitleX, detailListY, detailTitleWidth, kCellHeight)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:COLOR_TEXT];
        [titleLabel setText:title];
        [_contentBaseView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailContentX, detailListY, detailContentWidth, kCellHeight)];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        [contentLabel setTextColor:COLOR_TEXT];
        [contentLabel setTextAlignment:NSTextAlignmentRight];
        [contentLabel setAdjustsFontSizeToFitWidth:YES];
        [_contentBaseView addSubview:contentLabel];
        
        [_detailContentLabels addObject:contentLabel];
        detailListY += kCellHeight;
        
        [_contentBaseView drawLineFrom:CGPointMake(kCellContentLeftRightMargin, detailListY + 1)
                                    to:CGPointMake(contentBaseViewWidth - kCellContentLeftRightMargin, detailListY + 1)
                             lineWidth:1
                                 color:COLOR_SINGLE_LINE_ALPHA3
                                dotted:YES];
    }
}

- (void)setDetailContentLabelsText:(NSArray *)texts
{
    for (int i = 0; i < texts.count; i++) {
        if (i > _detailContentLabels.count) {
            return;
        }
        
        UILabel *contentLabel = [_detailContentLabels objectAtIndex:i];
        [contentLabel setText:[texts objectAtIndex:i]];
    }
}

@end
