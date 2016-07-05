//
//  VideosContentViewController.m
//  Football_NewProject
//
//  Created by Guitar on 16/7/5.
//  Copyright © 2016年 maleGod. All rights reserved.
//

#import "VideosContentViewController.h"
#import "ConnectManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideosContentViewController () {
    UILabel *_titleLabel;
    UILabel *_sourceLabel;
    UILabel *_publish_timeLabel;
    UIImageView *_videosImageView;
    UIActivityIndicatorView *_indicatorView;
    UILabel *_egLabel;
    MPMoviePlayerViewController *_mpVC;
}

@end

@implementation VideosContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSubview];
    [_indicatorView startAnimating];

    [[ConnectManager sharedManager] getDataWithURL:[NSString stringWithFormat:@"http://kapi.zucaitong.com/news/detail?id=%@", self.myId] params:nil success:^(id responseObj) {
        if (responseObj) {
            NSDictionary *dict = responseObj[@"data"];
            _titleLabel.text = dict[@"title"];
            _sourceLabel.text = dict[@"source"];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"YYYY-MM-dd";
            NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[dict[@"publish_time"] integerValue]];
            NSString *publishStr = [df stringFromDate:date];
            _publish_timeLabel.text = publishStr;
            [_videosImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"pic_small"]]];
            
            // 在body字段中视频的URL就在source src=\"之后
            NSArray *compArray = [dict[@"body"] componentsSeparatedByString:@"<source src=\""];
            NSArray *compArray1;
            if (compArray.count > 1) {
                compArray1 = [compArray.lastObject componentsSeparatedByString:@"\""];
                NSLog(@"%@", compArray1.firstObject);
                // 给图片添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
                _videosImageView.userInteractionEnabled = YES;
                [_videosImageView addGestureRecognizer:tap];
                // 初始化播放器
                _mpVC = [[MPMoviePlayerViewController alloc]init];
                _mpVC.moviePlayer.contentURL = [NSURL URLWithString:compArray1.firstObject];
                // 如果有视频URL，改变提示
                _egLabel.text = @"点击图片播放视频";
            }
            [_indicatorView stopAnimating];
        }
    } failure:^(NSError *error) {
        
    }];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    backItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    [_indicatorView stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 给图片加手势
- (void)tapAction:(UIGestureRecognizer *)gesture {
    if (_mpVC != nil) {
        [self presentMoviePlayerViewControllerAnimated:_mpVC];
    }
}

#pragma mark -- 布局
- (void)setSubview {
    // 刷新小菊花
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 130, 100, 100);
    _indicatorView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_indicatorView];
    
    _titleLabel = [self getLabelWithCGRect:CGRectMake(5, 5, mScreen_bounds.size.width, 25) fontName:@"TrebuchetMS" size:25.0f textColor:[UIColor blackColor]];
    [self.view addSubview:_titleLabel];
    _sourceLabel = [self getLabelWithCGRect:CGRectMake(5, CGRectGetMaxY(_titleLabel.frame) + 15, 65, 20) fontName:@"HelveticaNeue-Thin" size:16.0f textColor:[UIColor colorWithRed:0.590 green:0.891 blue:0.486 alpha:1.000]];
    [self.view addSubview:_sourceLabel];
    _publish_timeLabel = [self getLabelWithCGRect:CGRectMake(5 + _sourceLabel.frame.size.width, _sourceLabel.frame.origin.y, 110, 20) fontName:@"HelveticaNeue-Thin" size:16.0f textColor:[UIColor blackColor]];
    [self.view addSubview:_publish_timeLabel];
    
    _videosImageView = [[UIImageView alloc]init];
    _videosImageView.frame = CGRectMake(5, CGRectGetMaxY(_sourceLabel.frame) + 30, mScreen_bounds.size.width - 10, mScreen_bounds.size.height / 3);
    [self.view addSubview:_videosImageView];
    // 如果没有视频播放URL，提示显示暂无视频
    _egLabel = [self getLabelWithCGRect:(CGRectMake(mScreen_bounds.size.width / 2 - 60, CGRectGetMaxY(_videosImageView.frame) + 10, mScreen_bounds.size.width / 2 - 10, 10)) fontName:@"HelveticaNeue-Thin" size:13.0f textColor:[UIColor blackColor]];
    _egLabel.text = @"暂无视频";
    [self.view addSubview:_egLabel];
}

#pragma mark -- 创建label的方法
- (UILabel *)getLabelWithCGRect:(CGRect)rect fontName:(NSString *)fontName size:(CGFloat)size textColor:(UIColor *)color {
    UILabel * myLabel = [[UILabel alloc]initWithFrame:rect];
    myLabel.font = [UIFont fontWithName:fontName size:size];;
    myLabel.backgroundColor = [UIColor whiteColor];
    myLabel.textColor = color;
    return myLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
