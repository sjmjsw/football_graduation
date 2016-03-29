//
//  NewsTableViewCell.h
//  Football_NewProject
//
//  Created by Guitar on 3/25/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
