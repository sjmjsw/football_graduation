//
//  ReachabilityManager.h
//  Football_NewProject
//
//  Created by Guitar on 4/25/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

@property (nonatomic, strong) Reachability * wifi;
@property (nonatomic, strong) Reachability * dataTraffic;
@property (nonatomic, assign) BOOL havingNet;

+ (ReachabilityManager *)sharedManager;

@end
