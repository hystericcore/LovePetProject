//
//  LPDetailViewMapCell.m
//  LovePetProject
//
//  Created by hyunjoon.park on 13. 7. 31..
//  Copyright (c) 2013년 HyunJoon Park. All rights reserved.
//

#import "LPDetailViewMapCell.h"
#import <DaumMap/MTMapView.h>

#import "LPKeyDefines.h"
#import "UIView+Utils.h"

@interface LPDetailViewMapCell () <MTMapViewDelegate>
@property (nonatomic, strong) UIView *contentBaseView;
@property (nonatomic, strong) MTMapView *mapView;
@property (nonatomic, assign) BOOL showPOI;
@end
@implementation LPDetailViewMapCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showPOI = NO;
        [self setBackgroundColor:COLOR_GRAYWHITE];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self createcontentBaseView];
        [self createHeaderView];
        [self createMapView];
    }
    return self;
}

- (void)createcontentBaseView
{
    CGFloat contentBaseViewWidth = CGRectGetWidth(self.frame) - kCellMargin * 2;
    CGFloat contentBaseViewHeight = LPDetailViewMapCellHeight - kCellMargin;
    
    self.contentBaseView = [[UIView alloc] initWithFrame:CGRectMake(kCellMargin, 0,
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
    [titleLabel setText:@"보호소 위치"];
    
    [_contentBaseView addSubview:titleLabel];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"petdetail_map.png"]];
    CGRect titleImageFrame = CGRectMake(0, 0, 15, 15);
    titleImageFrame.origin.x = CGRectGetWidth(_contentBaseView.frame) - kCellContentLeftRightMargin - kCellContentLeftRightPadding - titleImageFrame.size.width;
    titleImageFrame.origin.y = titleLabel.center.y - titleImageFrame.size.height / 2;
    [titleImageView setFrame:titleImageFrame];
    
    [_contentBaseView addSubview:titleImageView];
}

- (void)createMapView
{
    CGFloat mapViewX = kCellContentLeftRightMargin;
    CGFloat mapViewY = kCellHeaderHeight + kCellContentLeftRightMargin;
    CGFloat mapViewWidth = CGRectGetWidth(_contentBaseView.frame) - kCellContentLeftRightMargin * 2;
    CGFloat mapViewHeight = kMapHeight;
    
    self.mapView = [[MTMapView alloc] initWithFrame:CGRectMake(mapViewX, mapViewY, mapViewWidth, mapViewHeight)];
    [_mapView setDaumMapApiKey:kLPDaumMapAPIKey];
    [_mapView setZoomLevel:5 animated:NO];
    _mapView.delegate = self;
    _mapView.baseMapType = MTMapTypeStandard;
    [_contentBaseView addSubview:_mapView];
}

#pragma mark - Set center location

- (void)setCenterLocation:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude
{
    if (latitude == nil || longitude == nil || _mapView.poiItems.count > 0) {
        return;
    }
    
    MTMapPoint *point = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake([latitude floatValue], [longitude floatValue])];
    
    // Move and Zoom to
    [_mapView setMapCenterPoint:point animated:YES];
    
    MTMapPOIItem* poiItem = [MTMapPOIItem poiItem];
    poiItem.itemName = [name stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    poiItem.mapPoint = point;
    poiItem.userObject = [NSString stringWithFormat:@"item%d", 2];
    poiItem.markerType = MTMapPOIItemMarkerTypeCustomImage;
    poiItem.showAnimationType = MTMapPOIItemShowAnimationTypeNoAnimation;
    poiItem.showDisclosureButtonOnCalloutBalloon = YES;
    poiItem.draggable = NO;
    poiItem.customImageName = @"petdetail_marker.png";
    
    [_mapView addPOIItem:poiItem];
}

- (void)MTMapView:(MTMapView*)mapView touchedCalloutBalloonOfPOIItem:(MTMapPOIItem*)poiItem
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"다음지도앱에서 이 위치를 보시겠습니까?"
                                                       delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"확인", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSString *queryString = [NSString stringWithFormat:@"daummaps://look?p=%f,%f", _mapView.mapCenterPoint.mapPointGeo.latitude, _mapView.mapCenterPoint.mapPointGeo.longitude];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

@end
