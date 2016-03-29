//
//  NewsModel.m
//  Football_NewProject
//
//  Created by Guitar on 3/25/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.newsId = value;
    }
}

@end
