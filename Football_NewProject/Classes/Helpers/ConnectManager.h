//
//  ConnectManager.h
//  Football_NewProject
//
//  Created by Guitar on 3/18/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectManager : NSObject

+ (instancetype)sharedManager;

- (void)getDataWithURL:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure;
- (void)postDataWithURL:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure;

@end
