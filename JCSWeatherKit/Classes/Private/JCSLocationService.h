//
//  JCSLocationService.h
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CLLocation, JCSWeatherError;

typedef void (^JCSLocationUpdatedCompletion)(CLLocation * _Nullable location, NSError * _Nullable error);


@interface JCSLocationService : NSObject

@property (nonatomic, copy) JCSLocationUpdatedCompletion updatedBlock;

+ (instancetype)service;

- (void)startLocationService;
- (void)stopLocationService ;

@end

NS_ASSUME_NONNULL_END
