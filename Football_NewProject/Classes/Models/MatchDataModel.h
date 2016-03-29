//
//  MatchDataModel.h
//  Football_NewProject
//
//  Created by Guitar on 3/29/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchDataModel : NSObject

@property (nonatomic, copy) NSString * myId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * pic;
@property (nonatomic, copy) NSString * ranking;
@property (nonatomic, copy) NSString * played;
@property (nonatomic, copy) NSString * win;
@property (nonatomic, copy) NSString * draw;
@property (nonatomic, copy) NSString * lose;
@property (nonatomic, copy) NSString * goal;
@property (nonatomic, copy) NSString * otherGoal;
@property (nonatomic, copy) NSString * integral;

@end
