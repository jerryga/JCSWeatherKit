//
//  JCSWeatherSession.h
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class JCSWeatherRequestInfo, JCSWeatherData;
@protocol JCSWeatherSourceProtocol;

/** Callback for Weather Session.
 *
 * @param data The data fetched by session.
 * @param error Non-nil if an error occurred..(such as invalid source).
 */
typedef void (^JCSWeatherSessionCompletion)(JCSWeatherData *_Nullable data, NSError * _Nullable error);


@interface JCSWeatherSession : NSObject

/// The weather source used by the weather session.
@property (nonatomic, strong) id <JCSWeatherSourceProtocol> weatherSrc;

/**
 Initializes a weather session using the given source.
 
 @param     source
            source to use, including URL, APIKey....
 @return    A newly initialized weather session.
 */
- (instancetype)initWithSource:(id <JCSWeatherSourceProtocol>)source NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

/**
 async get weather from online..
 
 @param     info
            the request  param
 @param     completion
            if finished, it will dispatch to the main thread.
 */
- (void)asyncGetWeather:(JCSWeatherRequestInfo * _Nullable )info completion:(JCSWeatherSessionCompletion)completion;

/**
 Check if you should send weather request again.
 The SDK internally judges whether the timestamp is greater than 24 hours.
 @return    YES/NO.
 */
- (BOOL)shouldRefreshWeather;

@end

NS_ASSUME_NONNULL_END
