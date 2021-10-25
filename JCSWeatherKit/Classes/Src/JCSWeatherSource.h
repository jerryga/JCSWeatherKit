//
//  JCSWeatherSource.h
//  JCSWeatherKit
//
//  Created by YangCheng on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import "JCSWeatherSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCSWeatherSource : NSObject<JCSWeatherSourceProtocol>

@property (nonatomic, copy, readonly) NSString *appid;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithBaseURL:(NSURL *)url appid:(NSString *)appid NS_DESIGNATED_INITIALIZER;

- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
