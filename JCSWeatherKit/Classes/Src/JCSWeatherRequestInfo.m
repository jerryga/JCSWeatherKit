//
//  JCSWeatherRequestInfo.m
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import "JCSWeatherRequestInfo.h"

//@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
//@property(nonatomic, copy) NSString *cityName;
//@property(nonatomic, copy) NSString *cityID;
//@property(nonatomic, copy) NSString *zipCode;

@implementation JCSWeatherRequestInfo

- (instancetype)init {
    if (self = [super init]) {
        self.coordinate = kCLLocationCoordinate2DInvalid;
    }
    return self;
}



@end
