//
//  JCSViewController.m
//  JCSWeatherKit
//
//  Created by jerryga on 10/24/2021.
//  Copyright (c) 2021 jerryga. All rights reserved.
//

#import "JCSViewController.h"
#import <JCSWeatherKit/JCSWeatherKit.h>
#import "UIViewController+Alert.h"

/*
 Test Data:
 
 Zip Code: 94040,us
 City ID: 5128638
 City Name: London
 
 */

#define K_Demo_WeatherDisplayMode @"K_Demo_WeatherDisplayMode"

typedef NS_ENUM(NSUInteger, JCSDemoGetWeatherMode){
    JCSDemoGetWeatherModeZipCode,
    JCSDemoGetWeatherModeCityName,
    JCSDemoGetWeatherModeCityID,
    JCSDemoGetWeatherModeCurrentLocation,
};

typedef NS_ENUM(NSUInteger, JCSDemoWeatherDisplayMode){
    JCSDemoWeatherDisplayModeKelvin,
    JCSDemoWeatherDisplayModeCelsius,
};

@interface JCSViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *windInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *windSummaryLabel;

@property (nonatomic, strong) JCSWeatherSession *session;
@property (nonatomic, strong) JCSWeatherData *weatherData;
@property (nonatomic, strong) JCSWeatherRequestInfo *requestInfo;

@property (nonatomic, assign) JCSDemoGetWeatherMode weatherMode;
@property (nonatomic, assign) JCSDemoWeatherDisplayMode displayMode;

@end

@implementation JCSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.displayMode = (JCSDemoWeatherDisplayMode)[[NSUserDefaults standardUserDefaults] integerForKey:K_Demo_WeatherDisplayMode];
    [self setupWeatherRequestInfo:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (JCSWeatherSession *)session {
    if (!_session) {
        JCSOpenWeatherSource *src = [[JCSOpenWeatherSource alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.openweathermap.org/data/2.5/weather"] appid:@"edfe4ace41a2a8b1b9c7b15885662313"];
        _session = [[JCSWeatherSession alloc] initWithSource:src];
    }
    return _session;
}

- (void)setupWeatherRequestInfo:(NSString *)info {
    JCSWeatherRequestInfo *requestInfo = nil;
    
    if (JCSDemoGetWeatherModeCurrentLocation != self.weatherMode) {
        requestInfo = [[JCSWeatherRequestInfo alloc] init];
        switch (self.weatherMode) {
            case JCSDemoGetWeatherModeZipCode:
            {
                requestInfo.zipCode = info;
            }
                break;
            case JCSDemoGetWeatherModeCityName:
            {
                requestInfo.cityName = info;
            }
                break;
            case JCSDemoGetWeatherModeCityID:
            {
                requestInfo.cityID = info;
            }
                break;

            default:
                break;
        }
    }
    self.requestInfo = requestInfo;
}

- (void)startGetWeather {
    __weak typeof(self) weakSelf = self;
    [self.session asyncGetWeather:self.requestInfo completion:^(JCSWeatherData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            [weakSelf setupWeatherView:data];
        }else {
            [weakSelf showAlert:@"Error!" msg:error.localizedFailureReason?:error.localizedDescription];
        }
    }];
}

- (void)alertUser:(NSString *)title {
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alert) weakAlert = alert;

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField =  weakAlert.textFields[0];
        if (0 != textField.text.length) {
            [weakSelf setupWeatherRequestInfo:textField.text];
            [weakSelf startGetWeather];
        }else {
            [weakSelf showAlert:@"Invalid input!" msg:@""];
        }
    }];
    

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    [alert addAction:okAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - UI

- (void)setupWeatherView:(JCSWeatherData *)data {
    self.weatherData = data;
    
    self.cityLabel.text = self.weatherData.cityName;
    self.windInfoLabel.text = [NSString stringWithFormat:@"Speed %.0f meter/sec\nDegree %.0f\ngust %.0f meter/sec", self.weatherData.wind.speed, self.weatherData.wind.direction, self.weatherData.wind.gust];
    self.weatherLabel.text = self.weatherData.summary;
    self.windSummaryLabel.text = @"Wind Summary";
    [self setIcon:self.weatherData.iconURL];
    
    [self setupTemperatureView];
}

- (void)setupTemperatureView {
    if (JCSDemoWeatherDisplayModeKelvin == self.displayMode) {
        self.temperatureLabel.text = [NSString stringWithFormat:@"%.0fK", self.weatherData.temperature.kelvin];
        self.maxMinLabel.text = [NSString stringWithFormat:@"H:%.0fK L:%.0fK", self.weatherData.maxTemperature.kelvin, self.weatherData.minTemperature.kelvin];
    }else {
        self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°", self.weatherData.temperature.celsius];
        self.maxMinLabel.text = [NSString stringWithFormat:@"H:%.0f° L:%.0f°", self.weatherData.maxTemperature.celsius, self.weatherData.minTemperature.celsius];
    }
}

- (void)setIcon:(NSURL *)iconURL {
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:iconURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.weatherImageView.image = [UIImage imageWithData:data];
        });
    }];
    [downloadTask resume];
}

#pragma mark - IBActions

- (IBAction)changeLocation:(id)sender {
    
    UIAlertAction *zipCodeAction = [UIAlertAction actionWithTitle:@"by zip code" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.weatherMode = JCSDemoGetWeatherModeZipCode;
        [self alertUser:@"Please input zip code"];
    }];
    UIAlertAction *cityNameAction = [UIAlertAction actionWithTitle:@"by city name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.weatherMode = JCSDemoGetWeatherModeCityName;
        [self alertUser:@"Please input city name"];
    }];
    UIAlertAction *cityIDAction = [UIAlertAction actionWithTitle:@"by city ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.weatherMode = JCSDemoGetWeatherModeCityID;
        [self alertUser:@"Please input city ID"];

    }];
    
    UIAlertAction *currentLocationAction = [UIAlertAction actionWithTitle:@"by current location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.weatherMode = JCSDemoGetWeatherModeCurrentLocation;
        [self setupWeatherRequestInfo:nil];
        [self startGetWeather];
    }];
    UIAlertController *alert = [self showAlert:@"Get the weather" msg:@"" doneAction:@[zipCodeAction, cityNameAction, cityIDAction, currentLocationAction] cancelTitle:@"Cancel" style:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)changeTemperatureDisplay:(id)sender {
    self.displayMode = ~self.displayMode;
    [[NSUserDefaults standardUserDefaults] setInteger:self.displayMode forKey:K_Demo_WeatherDisplayMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setupTemperatureView];
}

#pragma mark - Observer

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([self.session shouldRefreshWeather]) {
        [self startGetWeather];
    }
}

@end
