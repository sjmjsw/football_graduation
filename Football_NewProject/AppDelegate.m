//
//  AppDelegate.m
//  Football_NewProject
//
//  Created by Guitar on 3/18/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "ReachabilityManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    TabBarController * tabBar = [[TabBarController alloc]init];
    UINavigationController * tabBarNC = [[UINavigationController alloc]initWithRootViewController:tabBar];
    self.window.rootViewController = tabBarNC;
    [[ReachabilityManager sharedManager].wifi startNotifier];
    [[ReachabilityManager sharedManager].dataTraffic startNotifier];
    [self checkNetworkStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange) name:kReachabilityChangedNotification object:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)networkStatusChange {
    [self checkNetworkStatus];
}

- (void)checkNetworkStatus {
    if ([[ReachabilityManager sharedManager].wifi currentReachabilityStatus]) {
        [ReachabilityManager sharedManager].havingNet = YES;
        NSLog(@"wifi, %s, %d", __FUNCTION__, __LINE__);
    }else if ([[ReachabilityManager sharedManager].dataTraffic currentReachabilityStatus]) {
        [ReachabilityManager sharedManager].havingNet = YES;
        NSLog(@"流量, %s, %d", __FUNCTION__, __LINE__);
    }else {
        [ReachabilityManager sharedManager].havingNet = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatusIsNo" object:nil];
        NSLog(@"没网, %s, %d", __FUNCTION__, __LINE__);
    }
}

@end
