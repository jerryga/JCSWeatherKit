//
//  JCSOpenWeatherSource.m
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import "JCSOpenWeatherSource.h"
#import "JCSWeatherSourceProtocol.h"

@interface JCSOpenWeatherSource ()

@end

@implementation JCSOpenWeatherSource

@synthesize baseURL;
@synthesize appid;

- (instancetype)initWithBaseURL:(NSURL *)url appid:(NSString *)appid {
    if (self = [super init]) {
        self.baseURL = url;
        self.appid = appid;
    }
    return self;
}

- (BOOL)isValid {
    if (self.baseURL && self.baseURL.scheme && self.baseURL.host && self.appid){
        return YES;
    }else {
        return NO;
    }
}

@end
