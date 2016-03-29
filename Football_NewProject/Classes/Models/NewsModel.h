//
//  NewsModel.h
//  Football_NewProject
//
//  Created by Guitar on 3/25/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * newsId;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * pic_small;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, strong) NSString * publish_time;

@end
