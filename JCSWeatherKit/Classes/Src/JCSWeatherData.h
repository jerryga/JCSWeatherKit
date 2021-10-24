//
//  JCSWeatherData.h
//  JCSWeatherKit
//
//  Created by YangCheng on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    
    float kelvin;
    float celsius;
    
} JCSTemperature;

typedef struct {
    
    float speed;
    float direction;
    float gust;
    
} JCSWind;


@interface JCSWeatherData : NSObject

@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *detail;

@property (nonatomic, assign) JCSTemperature temperature;
@property (nonatomic, assign) JCSTemperature minTemperature;
@property (nonatomic, assign) JCSTemperature maxTemperature;

@property (nonatomic, assign) JCSWind wind;

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSDate *utcTimeStamp;

+ (JCSWeatherData *)weatherFromJSON:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
