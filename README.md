# JCSWeatherKit

[![CI Status](https://img.shields.io/travis/jerryga/JCSWeatherKit.svg?style=flat)](https://travis-ci.org/jerryga/JCSWeatherKit)
[![Version](https://img.shields.io/cocoapods/v/JCSWeatherKit.svg?style=flat)](https://cocoapods.org/pods/JCSWeatherKit)
[![License](https://img.shields.io/cocoapods/l/JCSWeatherKit.svg?style=flat)](https://cocoapods.org/pods/JCSWeatherKit)
[![Platform](https://img.shields.io/cocoapods/p/JCSWeatherKit.svg?style=flat)](https://cocoapods.org/pods/JCSWeatherKit)

JCSWeatherKit is a simple weather library for iOS.
It can fetch weather data from OpenWeatherMap. More data sources will be supported and extensions will be supported in the future.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 11.0+
## Installation

JCSWeatherKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JCSWeatherKit'
```
## Usage

There are a lot of unit tests in the file "JCSWeatherKitTests". You can refer to the usage method inside. Also, some code snippets are as followed.

### OpenWeatherMap

###### Creating a weather session

```objc
#import <JCSWeatherKit/JCSWeatherKit.h>

    JCSWeatherSource *src = [[JCSWeatherSource alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather"] appid:@"YOUR API KEY"];
    JCSWeatherSession *session = [[JCSWeatherSession alloc] initWithSource:src];
```
###### Getting weather by City ID

```objc
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.cityID = @"5128638";
    
    [self.session asyncGetWeather:requestInfo completion:^(JCSWeatherData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            //handle data
        }else {
           //show error
        }
    }];

```
###### Getting weather by City Name

```objc
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.cityName = @"London";
    
    [self.session asyncGetWeather:requestInfo completion:^(JCSWeatherData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            //handle data
        }else {
           //show error
        }
    }];

```
###### Getting weather by Zip Code

```objc
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.zipCode = @"94040,us";
    
    [self.session asyncGetWeather:requestInfo completion:^(JCSWeatherData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            //handle data
        }else {
           //show error
        }
    }];

```
###### Getting weather by Coordinate

```objc
    JCSWeatherRequestInfo *requestInfo = [[JCSWeatherRequestInfo alloc] init];
    requestInfo.coordinate = CLLocationCoordinate2DMake(43.700111, -79.416298);
    
    [self.session asyncGetWeather:requestInfo completion:^(JCSWeatherData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            //handle data
        }else {
           //show error
        }
    }];

```
###### Getting weather by user current location

```objc
    
    [self.session asyncGetWeather:nil completion:^(JCSWeatherData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            //handle data
        }else {
           //show error
        }
    }];

```

## Architecture 

JCSWeatherKit is implemented as a layered architecture.

    +-------------------------------------------------------------+
    |                         JCSWeatherKit                        |
    |        +----------------------------------------------------+
    |        |                  JCSWeatherSession                           |
    |    +--------------------------------------------------------+
    |    | JCSWeatherSource | JCSWeatherRequestInfo | JCSLocationService | 
    +----+-----------------+-----------------+--------------------+
    |       JCSWeatherData        |     JCSWeatherError    |
    +----------------------+-----------------+


### JCSWeatherSession

Provides asynchronous request of getting weather from OpenWeatherAPI. The input weather source needs to be set by the initial method or attribute.

Primary entry points: JCSWeatherSession.h,


### JCSWeatherSource

Provides configuration data, including APPID and base URL where JCSWeatherSession can get weather data from.

Primary entry point: JCSWeatherSource.h


### JCSWeatherRequestInfo

Used for passing parameters to OpenWeatherAPI, such as city id, city name, zip code, and so on.

In the category JCSWeatherRequestInfo+Private, splices URL through parameters.
Primary entry point: JCSWeatherRequestInfo.h


### JCSLocationService

Used for getting user location to fetch weather data.
 
Primary entry point: JCSLocationService.h


### JCSWeatherData

A data container for all weather data. Also provides transforming JSON data to all the weather data.

Primary entry point: JCSWeatherData.h


### JCSWeatherError

Defines errors types and passes control to a supplied function.
It handles the following errors:

* invalid weather source.
* disabled location service.


Primary entry point: JCSWeatherError.h

## Author

jerryga, staticga@gmail.com

## License

JCSWeatherKit is available under the MIT license. See the LICENSE file for more info.


