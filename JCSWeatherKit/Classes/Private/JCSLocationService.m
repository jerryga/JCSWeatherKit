//
//  JCSLocationService.m
//  JCSWeatherKit
//
//  Created by jerryga on 2021/10/21.
//

#import "JCSLocationService.h"
#import <CoreLocation/CoreLocation.h>
#import "JCSWeatherError.h"

@interface JCSLocationService ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation JCSLocationService

+ (instancetype)service {
    return [[[self class] alloc] init];
}

- (void)dealloc {
    
}
#pragma mark - Public

- (void)startLocationService {
    if ([CLLocationManager locationServicesEnabled]) {
        [self handleLocationServicesAuthorizationStatus:[CLLocationManager authorizationStatus]];
    }else {
        [self getLocationFailed];
    }
}

- (void)stopLocationService {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark - Private

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _locationManager.distanceFilter = 3000;
    }
    return _locationManager;
}

- (void)requestLocationServicesAuthorization {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }else {
        [self getLocationFailed];
    }
}

- (void)getLocationFailed {
    if (self.updatedBlock) {
        
        NSError *error = [NSError errorWithDomain:JCSWeatherErrorDomain
                                                    code:JCSWeatherErrorLocationDisabled
                                                userInfo:@{
                                                           NSLocalizedDescriptionKey: @"Location services are disabled."
                                                }];

        self.updatedBlock(nil, error);
    }
}

- (void)handleLocationServicesAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self requestLocationServicesAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self getLocationFailed];
            break;
        default:
            break;
    }
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (kCLAuthorizationStatusDenied == status) {
        [self getLocationFailed];
    }else if (kCLAuthorizationStatusAuthorizedWhenInUse == status || kCLAuthorizationStatusAuthorizedAlways == status) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    CLLocation *userLocation = locations[0];
    if (self.lastLocation) {
        if ([userLocation distanceFromLocation:self.lastLocation] > 3000) {
            self.lastLocation = userLocation;
        }
    }else {
        self.lastLocation = userLocation;
    }
    
    if (self.updatedBlock) {
        __weak typeof(self) weakSelf = self;
        self.updatedBlock(weakSelf.lastLocation, nil);
    }
}

@end
