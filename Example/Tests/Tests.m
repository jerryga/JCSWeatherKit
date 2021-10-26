//
//  JCSWeatherKitTests.m
//  JCSWeatherKitTests
//
//  Created by jerryga on 10/24/2021.
//  Copyright (c) 2021 jerryga. All rights reserved.
//

@import XCTest;

#import "JCSWeatherKit.h"

@interface JCSWeatherKitTests : XCTestCase

@end

@implementation JCSWeatherKitTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

/*
{
    "id": 6167865,
    "name": "Toronto",
    "state": "",
    "country": "CA",
    "coord": {
        "lon": -79.416298,
        "lat": 43.700111
    }
}*/
- (void)testWeatherByLocation {
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.coordinate = CLLocationCoordinate2DMake(43.700111, -79.416298);
    [self getWeather:requestInfo];
}

/*
 London
 */
- (void)testWeatherByCityName {
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.cityName = @"London";
    [self getWeather:requestInfo];
}

/*
 {
     "id": 5128638,
     "name": "New York",
     "state": "NY",
     "country": "US",
     "coord": {
         "lon": -75.499901,
         "lat": 43.000351
     }
 }
 */
- (void)testWeatherByCityID {
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.cityID = @"5128638";
    [self getWeather:requestInfo];
}

/*
 Mountain View
 */
- (void)testWeatherByZipCode {
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.zipCode = @"94040,us";
    [self getWeather:requestInfo];
}

- (void)getWeather:(JCSWeatherRequestInfo *)info {
    XCTestExpectation* expectation = [self expectationWithDescription:@"request weather failed..."];

    JCSOpenWeatherSource *src = [[JCSOpenWeatherSource alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather"] appid:@"edfe4ace41a2a8b1b9c7b15885662313"];
    JCSWeatherSession *session = [[JCSWeatherSession alloc] initWithSource:src];
    
    [session asyncGetWeather:info completion:^(JCSWeatherData * _Nullable data, NSError * _Nullable error) {
        XCTAssertNotNil(data);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"weather session error %@", error);
        }
    }];

}

@end

