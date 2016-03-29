//
//  MatchDataTableViewCell.h
//  Football_NewProject
//
//  Created by Guitar on 3/29/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ranking;
@property (weak, nonatomic) IBOutlet UIImageView *teamPic;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *played;
@property (weak, nonatomic) IBOutlet UILabel *win;
@property (weak, nonatomic) IBOutlet UILabel *draw;
@property (weak, nonatomic) IBOutlet UILabel *lose;
@property (weak, nonatomic) IBOutlet UILabel *goalAndOtherGoal;
@property (weak, nonatomic) IBOutlet UILabel *integral;

@end
