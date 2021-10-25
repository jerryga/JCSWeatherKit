//
//  JCSWeatherSource.m
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import "JCSWeatherSource.h"

@interface JCSWeatherSource ()

@property (nonatomic, copy, readwrite) NSString *appid;

@end

@implementation JCSWeatherSource

@synthesize baseURL;

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
