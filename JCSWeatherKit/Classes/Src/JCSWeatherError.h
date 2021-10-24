//
//  JCSWeatherError.h
//  JCSWeatherKit
//
//  Created by YangCheng on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const JCSWeatherErrorDomain;

typedef NS_ERROR_ENUM(JCSWeatherErrorDomain, JCSWeatherErrorCode) {
    JCSWeatherErrorUnknown = 0,
    JCSWeatherErrorInvalidWeatherSource,
    JCSWeatherErrorLocationDisabled,
} ;



NS_ASSUME_NONNULL_END
