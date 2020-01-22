//
//  AppDelegate.m
//  HBDynamicForms
//
//  Created by mastercom on 2018/3/28.
//  Copyright © 2018年 MT. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    [self setupBMap];
    
    return YES;
}

- (void)setupBMap {
    
    _mapManager = [[BMKMapManager alloc] init];
    //!!!!: 注意申请的key的安全码与项目中的bundle id要匹配一致,否则即使能定位经纬度,也会导致地理反编译失败
    int ret = [_mapManager start:@"n15lS26jzpdCfjuSN1kBbbiwKQxxybid" generalDelegate:nil];
    if (ret < 0) {
        NSLog(@"BMKMapManager start failed!");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
