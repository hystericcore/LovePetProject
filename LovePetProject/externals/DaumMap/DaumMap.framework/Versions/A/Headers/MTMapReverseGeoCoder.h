/**
 * @brief Map POI Item Class
 * @file MTMapReverseGeoCoder.h
 * @author Byung-Wan Lim (bwlim@daumcorp.com)
 * @date 2011/11/17
 * @copyright
 * Copyright 2012 Daum Communications Corp. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <DaumMap/MTMapGeometry.h>

@class MTMapReverseGeoCoderInternal;
@protocol MTMapReverseGeoCoderDelegate;

/**
 * @brief 지도 좌표를 주소 정보로 변환(Reverse Geo-Coding)하는 기능을 제공하는 Class
 */
@interface MTMapReverseGeoCoder : NSObject {
@private
	MTMapReverseGeoCoderInternal* _internalImpl;
}

/**
 * MTMapReverseGeoCoder 객체를 생성한다.
 * 주소정보를 알고자 하는 지도 좌표와 Reverse Geo-coding 결과를 통보받을 수 있는 delegate 객체를 설정한다.
 * 비동기(Asynchronous) 방식으로 Reverse Geo-coding을 수행하고자 하는 경우 MTMapReverseGeoCoder 객체를 생성한다.
 * 동기(Synchronous, Blocking) 방식으로 Reverse Geo-coding을 실행하는 경우에는 findAddressForMapPoint:withAddressType: static 메소드를 사용한다.
 * @param mapPoint 주소정보로 변화하고자하는 지도 좌표
 * @param delegate Reverse Geo-coding 결과를 통보받을 수 있는 delegate 객체
 * @param openAPIKey Open API Key
 */
- (id)initWithMapPoint:(MTMapPoint*)mapPoint withDelegate:(id<MTMapReverseGeoCoderDelegate>)delegate withOpenAPIKey:(NSString*)openAPIKey;


/**
 * Reverse Geo-coding(Asynchronous) 서비스를 요청한다.
 * 주소 정보는 비동기 방식으로 delegate 객체에 전달된다.
 */
- (void)startFindingAddress;

/**
 * Reverse Geo-coding(Asynchronous) 서비스 요청을 취소한다.
 */
- (void)cancelFindingAddress;

/**
 * 동기(Synchronous, Blocking) 방식으로 Reverse Geo-coding 을 수행한다.
 * 메소드를 호출한 thread는 Reverse Geo-Coding 서비스가 수행되는 동한 block된 후
 * 변환된 주소정보를 리턴받는다.
 * @param mapPoint 주소정보로 변화하고자하는 지도 좌표
 * @param openAPIKey Open API Key
 * @return 주소정보 문자열
 */
+ (NSString *)findAddressForMapPoint:(MTMapPoint*)mapPoint withOpenAPIKey:(NSString*)openAPIKey;

@end


/**
 * Reverse Geo-Coding 결과를 비동기적으로 통보받는 객체가 구현해야하는 interface protocol
 */
@protocol MTMapReverseGeoCoderDelegate <NSObject>
@required

/**
 * 주소를 찾은 경우 호출된다.
 * @param rGeoCoder MTMapReverseGeoCoder 객체
 * @param addressString 결과 주소 문자열
 */
- (void)MTMapReverseGeoCoder:(MTMapReverseGeoCoder*)rGeoCoder foundAddress:(NSString*)addressString;

/**
 * Reverse Geo-Coding 서비스 호출에 실패한 경우 호출된다.
 * @param rGeoCoder MTMapReverseGeoCoder 객체
 * @param error NSError 객체
 */
- (void)MTMapReverseGeoCoder:(MTMapReverseGeoCoder*)rGeoCoder failedToFindAddressWithError:(NSError*)error;
@end
