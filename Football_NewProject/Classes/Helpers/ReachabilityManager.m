//
//  ReachabilityManager.m
//  Football_NewProject
//
//  Created by Guitar on 4/25/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ReachabilityManager alloc]init];
        manager.wifi = [Reachability reachabilityForLocalWiFi];
        manager.dataTraffic = [Reachability reachabilityForInternetConnection];
    });
    return manager;
}

@end
