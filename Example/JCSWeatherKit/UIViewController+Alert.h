//
//  UIViewController+Alert.h
//  JCSWeatherKit
//
//  Created by jerryga on 10/24/2021.
//  Copyright (c) 2021 jerryga. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)
- (void)showAlert:(NSString *)title msg:(NSString *)msg;
- (void)showAlert:(NSString *)title msg:(NSString *)msg completion:(void(^__nullable)(void))completion;
- (UIAlertController *)showAlert:(NSString *)title msg:(NSString *)msg doneAction:(NSArray * _Nullable)actions style:(UIAlertControllerStyle)style;
- (UIAlertController *)showAlert:(NSString *)title msg:(NSString *)msg doneAction:(NSArray * _Nullable)actions cancelTitle:(NSString *)cancelStr style:(UIAlertControllerStyle)style;
@end

NS_ASSUME_NONNULL_END
