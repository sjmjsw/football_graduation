//
//  AliveModel.h
//  Football_NewProject
//
//  Created by Guitar on 16/7/2.
//  Copyright © 2016年 maleGod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliveModel : NSObject

@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSString *homePic;
@property (nonatomic, copy) NSString *homeId;
@property (nonatomic, copy) NSString *home_score;
@property (nonatomic, copy) NSString *home_vote_num;
@property (nonatomic, copy) NSString *away_vote_num;
@property (nonatomic, copy) NSString *awayName;
@property (nonatomic, copy) NSString *awayPic;
@property (nonatomic, copy) NSString *awayId;
@property (nonatomic, copy) NSString *away_score;
@property (nonatomic, copy) NSString *match_time;
@property (nonatomic, copy) NSString *start_time;

@end
