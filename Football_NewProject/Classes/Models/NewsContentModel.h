//
//  NewsContentModel.h
//  Football_NewProject
//
//  Created by Guitar on 3/28/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsContentModel : NSObject

@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSString * publish_time;
@property (nonatomic, strong) NSString * pic_small;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, strong) NSString * title;

@end
