//
//  JCSWeatherRequestInfo+Private.m
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import "JCSWeatherRequestInfo+Private.h"
#import "JCSWeatherSourceProtocol.h"

@implementation JCSWeatherRequestInfo (Private)

- (NSArray<NSURLQueryItem *> *)queryItemsWithParameters:(NSDictionary<NSString *, NSString *> *)dict {

    if ([dict isKindOfClass:[NSDictionary class]] && [dict count] > 0) {
        NSMutableArray<NSURLQueryItem *> *itemsArray = @[].mutableCopy;
        for (NSString *keyStr in dict.allKeys) {
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:keyStr value:dict[keyStr]];
            [itemsArray addObject:item];
        }
        return itemsArray;
    }
    
    return nil;
}

- (NSDictionary *)toDic {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    if (CLLocationCoordinate2DIsValid(self.coordinate)) {
        [mDic setObject:[NSString stringWithFormat:@"%f", self.coordinate.latitude] forKey:@"lat"];
        [mDic setObject:[NSString stringWithFormat:@"%f", self.coordinate.longitude] forKey:@"lon"];
    }
    if (self.cityName) {
        [mDic setObject:self.cityName forKey:@"q"];
    }
    
    if (self.cityID) {
        [mDic setObject:self.cityID forKey:@"id"];
    }
    
    if (self.zipCode) {
        [mDic setObject:self.zipCode forKey:@"zip"];
    }
    return [mDic copy];
}

- (NSURL *)urlWithSrc:(id<JCSWeatherSourceProtocol>)src {

    NSURLComponents *components = [NSURLComponents componentsWithString:src.baseURL.absoluteString];
  
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self toDic]];
    if (src.appid) {
        [dict setObject:src.appid forKey:@"appid"];
    }
    components.queryItems = [self queryItemsWithParameters:dict];
    
    return components.URL;
}
@end
