//
//  JCSOpenWeatherSource.h
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import "JCSWeatherSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCSOpenWeatherSource : NSObject<JCSWeatherSourceProtocol>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithBaseURL:(NSURL *)url appid:(NSString *)appid NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
