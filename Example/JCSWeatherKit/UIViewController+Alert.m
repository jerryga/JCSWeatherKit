//
//  UIViewController+Alert.m
//  JCSWeatherKit
//
//  Created by jerryga on 10/24/2021.
//  Copyright (c) 2021 jerryga. All rights reserved.
//

#import "UIViewController+Alert.h"

@interface UIViewController ()

@end

@implementation UIViewController (Alert)

- (void)showAlert:(NSString *)title msg:(NSString *)msg completion:(void (^)(void))completion{
    UIAlertController *alert = nil;
    if (msg) {
        alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    }else {
        alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg {
    [self showAlert:title msg:msg completion:NULL];
}

- (UIAlertController *)showAlert:(NSString *)title msg:(NSString *)msg doneAction:(NSArray * _Nullable)actions style:(UIAlertControllerStyle)style{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addAction:obj];
    }];
    [alert addAction:cancelAction];
    return alert;
}

- (UIAlertController *)showAlert:(NSString *)title msg:(NSString *)msg doneAction:(NSArray * _Nullable)actions cancelTitle:(NSString *)cancelStr style:(UIAlertControllerStyle)style{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr?:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addAction:obj];
    }];
    [alert addAction:cancelAction];
    return alert;
}

@end
