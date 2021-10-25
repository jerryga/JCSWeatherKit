//
//  JCSWeatherSession.m
//  JCSWeatherKit
//
//  Created by YangCheng on 2021/10/21.
//

#import "JCSWeatherSession.h"
#import "JCSWeatherSource.h"
#import "JCSWeatherRequestInfo.h"
#import "JCSWeatherRequestInfo+Private.h"
#import "JCSWeatherData.h"
#import "JCSWeatherError.h"
#import "JCSLocationService.h"
#import <UIKit/UIKit.h>

#define K_DAY_HOUR 3600

@interface JCSWeatherSession ()

@property (nonatomic, strong) JCSWeatherRequestInfo *requestInfo;
@property (nonatomic, strong) JCSLocationService *locationService;
@property (nonatomic, strong) JCSWeatherData* currentWeather;
@property (nonatomic, copy) JCSWeatherSessionCompletion weatherCompletion;

@property (nonatomic, strong) dispatch_queue_t dataQueue;

@end

@implementation JCSWeatherSession

- (instancetype)initWithSource:(JCSWeatherSource *)source {
    if (self = [super init]) {
        
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        NSString *queueName = [NSString stringWithFormat:@"%@.session.dataqueue.%@", bundleIdentifier, [[NSUUID UUID] UUIDString]];
        self.dataQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        self.weatherSrc = source;

    }
    return self;
}

- (instancetype)init {
    return [self initWithSource:nil];
}

#pragma mark - Public

- (void)asyncGetWeather:(JCSWeatherRequestInfo *)info completion:(JCSWeatherSessionCompletion)completion {

    if (!self.weatherSrc || ![self.weatherSrc isValid]) {
    
        if (completion) {
            NSError *weatherError = [NSError errorWithDomain:JCSWeatherErrorDomain
                                                        code:JCSWeatherErrorInvalidWeatherSource
                                                    userInfo:@{
                                                               NSLocalizedDescriptionKey: @"The base url or appid is invalid."
                                                    }];
            completion(nil, weatherError);
        }
        return;
    }

    self.weatherCompletion = completion;

    if (!info) {
        //get user current location
        if (!self.locationService) {
            self.locationService = [JCSLocationService service];
            __weak typeof(self) weakSelf = self;
            self.locationService.updatedBlock = ^(CLLocation * _Nullable location, NSError * _Nullable error) {
                if (error) {
                    if (completion) {
                        completion(nil, error);
                    }
                }else {
                    JCSWeatherRequestInfo *locationInfo = [[JCSWeatherRequestInfo alloc] init];
                    locationInfo.coordinate = location.coordinate;
                    weakSelf.requestInfo = info;
                    [weakSelf sendRequest:locationInfo completion:completion];
                }
            };
        }
        
        [self.locationService startLocationService];
        
    }else {
        self.requestInfo = info;
        [self sendRequest:info completion:completion];
    }
}

- (BOOL)shouldRefreshWeather {
    if (!self.currentWeather || [[NSDate date] timeIntervalSinceDate:self.currentWeather.utcTimeStamp] >= K_DAY_HOUR) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - Private

- (void)sendRequest:(JCSWeatherRequestInfo *)info completion:(JCSWeatherSessionCompletion)completion{
    NSURL *url = [info urlWithSrc:self.weatherSrc];
    NSURLSession *session = [NSURLSession sharedSession];

    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(self.dataQueue, ^{
            JCSWeatherData *weatherData = nil;
            NSError *resultError = error;

            if (data) {
                NSError *jsonErr = nil;
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonErr];
                if (!jsonErr) {
                    weatherData = [JCSWeatherData weatherFromJSON:JSON];
                }else {
                    resultError = jsonErr;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentWeather = weatherData;
                if (completion) {
                    completion(weatherData, resultError);
                }
            });
        });
          
        }] resume];
}



@end
