//
//  JCSWeatherData.m
//  JCSWeatherKit
//
//  Created by YangCheng on 2021/10/21.
//

#import "JCSWeatherData.h"


@implementation JCSWeatherData

float Kelvin_to_Celsius(float K)
{
    return (K - 273.15);
}

+ (JCSWeatherData *)weatherFromJSON:(NSDictionary *)json {
    
    JCSWeatherData *weatherData = [[JCSWeatherData alloc] init];
    
    NSArray *weathers = [json objectForKey:@"weather"];
    if ([weathers isKindOfClass:[NSArray class]] && weathers.count > 0) {
        NSDictionary *item = weathers[0];
        if ([item isKindOfClass:[NSDictionary class]]) {
            weatherData.summary = item[@"main"];
            weatherData.detail = item[@"description"];
            weatherData.iconName = item[@"icon"];
        }
    }
    
    NSDictionary *temperInfo = [json objectForKey:@"main"];
    if (temperInfo && [temperInfo isKindOfClass:[NSDictionary class]]) {
        if (temperInfo[@"temp"]) {
            float currentTemper = [temperInfo[@"temp"] floatValue];
            weatherData.temperature = (JCSTemperature){currentTemper, Kelvin_to_Celsius(currentTemper)};
        }
        
        if (temperInfo[@"temp_min"]) {
            float minTemper = [temperInfo[@"temp_min"] floatValue];
            weatherData.minTemperature = (JCSTemperature){minTemper, Kelvin_to_Celsius(minTemper)};
        }
        
        if (temperInfo[@"temp_max"]) {
            float maxTemper = [temperInfo[@"temp_max"] floatValue];
            weatherData.maxTemperature = (JCSTemperature){maxTemper, Kelvin_to_Celsius(maxTemper)};
        }
    }
    
    NSDictionary *windDic = [json objectForKey:@"wind"];
    if (windDic && [windDic isKindOfClass:[NSDictionary class]]) {
        JCSWind wind = {FLT_MAX, FLT_MAX, FLT_MAX};
        if (windDic[@"speed"]) {
            wind.speed = [windDic[@"speed"] floatValue];
        }
        if (windDic[@"deg"]) {
            wind.direction = [windDic[@"deg"] floatValue];
        }
        if (windDic[@"gust"]) {
            wind.gust = [windDic[@"gust"] floatValue];
        }
        
        weatherData.wind = wind;
    }
    
    NSString *name = [json objectForKey:@"name"];
    if (name) {
        weatherData.cityName = name;
    }
    
    NSString *dt = [json objectForKey:@"dt"];
    if (dt) {
        weatherData.utcTimeStamp = [NSDate dateWithTimeIntervalSince1970: [dt doubleValue]];
    }

    return weatherData;
}

- (NSURL *)iconURL {
    NSURL *url = nil;
    if (self.iconName) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/wn/%@@2x.png", self.iconName]];
    }
    return url;
}
@end
