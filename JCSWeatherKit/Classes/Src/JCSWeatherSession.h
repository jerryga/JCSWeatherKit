//
//  JCSWeatherSession.h
//  JCSWeatherKit
//
//  Created by YangCheng on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@class JCSWeatherSource, JCSWeatherData, JCSWeatherRequestInfo;

typedef void (^JCSWeatherSessionCompletion)(JCSWeatherData * _Nullable data, NSError * _Nullable error);


@interface JCSWeatherSession : NSObject

@property (nonatomic, strong) JCSWeatherSource *weatherSrc;

- (instancetype)initWithSource:(nonnull JCSWeatherSource *)source NS_DESIGNATED_INITIALIZER;

- (void)asyncGetWeather:(JCSWeatherRequestInfo * _Nullable )info completion:(JCSWeatherSessionCompletion)completion;
- (BOOL)shouldRefreshWeather;

@end

NS_ASSUME_NONNULL_END
