//
//  JCSWeatherSourceProtocol.h
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCSWeatherSourceProtocol <NSObject>

@required

@property (nonatomic, strong) NSURL *baseURL;
 
@end

NS_ASSUME_NONNULL_END
