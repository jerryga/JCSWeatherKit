//
//  JCSWeatherRequestInfo.h
//  JCSWeatherKit
//
//  Created by YangCheng on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCSWeatherRequestInfo : NSObject

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSString *cityID;
@property(nonatomic, copy) NSString *zipCode;
 
@end

NS_ASSUME_NONNULL_END
