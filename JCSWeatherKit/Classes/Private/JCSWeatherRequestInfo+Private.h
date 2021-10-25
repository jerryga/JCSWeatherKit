//
//  JCSWeatherRequestInfo+Private.h
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import "JCSWeatherRequestInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class JCSWeatherSource;

@interface JCSWeatherRequestInfo (Private)
- (NSURL *)urlWithSrc:(JCSWeatherSource *)src;
@end

NS_ASSUME_NONNULL_END
