//
//  FISViewController.m
//  gunnaRain
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import <Forecastr/Forecastr+CLLocation.h>
@interface FISViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FISViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
    
    Forecastr *currentLocation = [Forecastr sharedManager];
    currentLocation.apiKey = @"fd5cc9d02f31f3c3bc8339134b322acf";

    CLLocation *theCurrentLocation = [self.locationManager location];
    [currentLocation getForecastForLocation:theCurrentLocation time:nil exclusions:nil extend:nil success:^(id JSON) {
        NSInteger rainNumber = [JSON[@"currently"][@"precipProbability"] integerValue];
        NSLog(@"%@", JSON[@"currently"]);
        BOOL isRaining = 1;
        
        if (rainNumber == isRaining) {
            self.weatherStatus.textColor = [UIColor redColor];
            self.weatherStatus.text = @"Yep";
        }
        if (!rainNumber == isRaining)
        {
            self.weatherStatus.textColor = [UIColor greenColor];
            self.weatherStatus.text = @"Nope";
        }
        
        if (rainNumber > 0.25 && rainNumber < 1) {
            self.weatherStatus.textColor = [UIColor blackColor];
            self.weatherStatus.text = @"Maybe";
        }

    }
                                     failure:^(NSError *error, id response) {
        NSLog(@"%@", [error description]);
    }];

 
    
    
//    Forecastr *forecastr = [Forecastr sharedManager];
//    forecastr.apiKey = @"fd5cc9d02f31f3c3bc8339134b322acf";
//
//    [forecastr getForecastForLatitude:41.8369 longitude:87.6847 time:nil exclusions:nil extend:nil success:^(id JSON)
//    
//    {
//        NSInteger rainNumber = [JSON[@"currently"][@"precipProbability"] integerValue];
//        NSLog(@"%@", JSON[@"currently"]);
//        BOOL isRaining = 1;
//        
//        if (rainNumber == isRaining) {
//            self.weatherStatus.textColor = [UIColor redColor];
//            self.weatherStatus.text = @"Yep";
//        }
//        if (!rainNumber == isRaining)
//        {
//            self.weatherStatus.textColor = [UIColor greenColor];
//            self.weatherStatus.text = @"Nope";
//        }
//        
//        if (rainNumber > 0.25 && rainNumber < 1) {
//            self.weatherStatus.textColor = [UIColor blackColor];
//            self.weatherStatus.text = @"Maybe";
//        }
//        
//    }
//
//failure:^(NSError *error, id response)
//    {
//        NSLog(@"%@", [error description]);
//    }
//     ];
//
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
