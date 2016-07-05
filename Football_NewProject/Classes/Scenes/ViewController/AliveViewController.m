//
//  AliveViewController.m
//  Football_NewProject
//
//  Created by Guitar on 16/7/2.
//  Copyright © 2016年 maleGod. All rights reserved.
//

#import "AliveViewController.h"
#import "ConnectManager.h"
#import "AliveModel.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "NewsContentViewController.h"

@interface AliveViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIImageView *homeImageView;
@property (nonatomic, strong) UIImageView *awayImageView;
@property (nonatomic, strong) UILabel *homeNameLabel;
@property (nonatomic, strong) UILabel *awayNameLabel;
@property (nonatomic, strong) UILabel *homeScoreLabel;
@property (nonatomic, strong) UILabel *awayScoreLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *matchTimeLabel;
// 新闻
@property (nonatomic, strong) UITableView *newsTableView;
@property (nonatomic, strong) NSMutableArray *allDataArray;
@end

@implementation AliveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak AliveViewController *weakSelf = self;
    [[ConnectManager sharedManager] getDataWithURL:[NSString stringWithFormat:@"http://kapi.zucaitong.com/match/detail?id=%@", self.myId] params:nil success:^(id responseObj) {
        if (responseObj) {
            if ([responseObj[@"message"] isEqualToString:@"成功"]) {
                NSDictionary *dic = responseObj[@"data"];
                NSDictionary *teamDic = dic[@"team"];
                NSDictionary *homeDic = teamDic[@"home"];
                NSDictionary *awayDic = teamDic[@"away"];
                AliveModel *alive = [[AliveModel alloc]init];
                [alive setValue:dic[@"match_time"] forKey:@"match_time"];
                [alive setValue:dic[@"start_time"] forKey:@"start_time"];
                [alive setValue:dic[@"home_vote_num"] forKey:@"home_vote_num"];
                [alive setValue:dic[@"away_vote_num"] forKey:@"away_vote_num"];
                [alive setValue:dic[@"home_score"] forKey:@"home_score"];
                [alive setValue:dic[@"away_score"] forKey:@"away_score"];
                [alive setValue:homeDic[@"name"] forKey:@"homeName"];
                [alive setValue:awayDic[@"name"] forKey:@"awayName"];
                [alive setValue:homeDic[@"pic"] forKey:@"homePic"];
                [alive setValue:awayDic[@"pic"] forKey:@"awayPic"];
                [alive setValue:homeDic[@"id"] forKey:@"homeId"];
                [alive setValue:awayDic[@"id"] forKey:@"awayId"];
                [weakSelf.homeImageView sd_setImageWithURL:[NSURL URLWithString:alive.homePic] placeholderImage:[UIImage imageNamed:@""] options:0];
                [weakSelf.awayImageView sd_setImageWithURL:[NSURL URLWithString:alive.awayPic] placeholderImage:[UIImage imageNamed:@""] options:0];
                weakSelf.homeNameLabel.text = alive.homeName;
                weakSelf.awayNameLabel.text = alive.awayName;
                weakSelf.homeScoreLabel.text = alive.home_score;
                weakSelf.awayScoreLabel.text = alive.away_score;
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                df.dateFormat = @"MM-dd HH:mm";
                NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:alive.match_time.integerValue];
                NSString *dateStr = [df stringFromDate:date];
                weakSelf.matchTimeLabel.text = dateStr;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"失败了, %@", error);
    }];
    [[ConnectManager sharedManager] getDataWithURL:[NSString stringWithFormat:@"http://kapi.zucaitong.com/match/news?id=%@&last_id=0&page_size=20", self.myId] params:nil success:^(id responseObj) {
        if (responseObj) {
            weakSelf.allDataArray = [NSMutableArray array];
            NSArray * arr = responseObj[@"data"];
            for (NSDictionary * dic in arr) {
                NewsModel * nModel = [[NewsModel alloc]init];
                [nModel setValue:dic[@"title"] forKey:@"title"];
                [nModel setValue:dic[@"summary"] forKey:@"summary"];
                [nModel setValue:dic[@"pic_small"] forKey:@"pic_small"];
                [nModel setValue:dic[@"id"] forKey:@"id"];
                [nModel setValue:dic[@"source"] forKey:@"source"];
                [nModel setValue:dic[@"publish_time"] forKey:@"publish_time"];
                [weakSelf.allDataArray addObject:nModel];
            }
            [weakSelf.newsTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    [self setSubView];
}

- (void)setSubView {
    // 导航栏
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.487 green:0.863 blue:0.561 alpha:1.000];
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    // 顶部绿色底板
    self.greenView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, mScreen_bounds.size.width, mScreen_bounds.size.height / 5))];
    _greenView.backgroundColor = [UIColor colorWithRed:0.386 green:0.834 blue:0.532 alpha:1.000];
    [self.view addSubview:_greenView];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    backButton.frame = CGRectMake(10, 20, 30, 20);
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [backButton setTitle:@"<" forState:(UIControlStateNormal)];
    [backButton setTintColor:[UIColor whiteColor]];
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [_greenView addSubview:backButton];
    
    self.homeImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(mScreen_bounds.size.width / 6, _greenView.frame.size.height / 5 + 10, mScreen_bounds.size.width / 7, mScreen_bounds.size.width / 7))];
    self.homeImageView.backgroundColor = [UIColor colorWithRed:0.386 green:0.834 blue:0.532 alpha:1.000];
    [_greenView addSubview:_homeImageView];
    self.awayImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(mScreen_bounds.size.width - self.homeImageView.frame.origin.x - self.homeImageView.frame.size.width, _greenView.frame.size.height / 5 + 10, mScreen_bounds.size.width / 7, mScreen_bounds.size.width / 7))];
    self.awayImageView.backgroundColor = [UIColor colorWithRed:0.386 green:0.834 blue:0.532 alpha:1.000];
    [_greenView addSubview:self.awayImageView];
    
    self.homeNameLabel = [self labelLayoutWithx:self.homeImageView.frame.origin.x - 5 y:CGRectGetMaxY(self.homeImageView.frame) width:self.homeImageView.frame.size.width + 10 height:20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter fontSize:13.0f];
    [_greenView addSubview:_homeNameLabel];
    
    self.awayNameLabel = [self labelLayoutWithx:self.awayImageView.frame.origin.x - 5 y:CGRectGetMaxY(self.awayImageView.frame) width:self.awayImageView.frame.size.width + 10 height:20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter fontSize:13.0f];
    [_greenView addSubview:_awayNameLabel];

    self.homeScoreLabel = [self labelLayoutWithx:mScreen_bounds.size.width / 2 - 33 y:CGRectGetMidY(self.homeImageView.frame) width:30 height:20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter fontSize:20.0f];
    [_greenView addSubview:_homeScoreLabel];

    self.awayScoreLabel = [self labelLayoutWithx:mScreen_bounds.size.width / 2 + 3 y:CGRectGetMidY(self.homeImageView.frame) width:30 height:20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter fontSize:20.0f];
    [_greenView addSubview:_awayScoreLabel];
    
    self.middleLabel = [self labelLayoutWithx:self.awayScoreLabel.frame.origin.x - 6 y:self.awayScoreLabel.frame.origin.y width:6 height:20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter fontSize:20.0f];
    self.middleLabel.text = @":";
    [_greenView addSubview:_middleLabel];
    
    self.matchTimeLabel = [self labelLayoutWithx:mScreen_bounds.size.width / 2 - 50 y:CGRectGetMinY(self.homeNameLabel.frame) width:100 height:20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter fontSize:13.0f];
    [_greenView addSubview:_matchTimeLabel];
    // 下部新闻页面
    self.newsTableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.greenView.frame), mScreen_bounds.size.width, mScreen_bounds.size.height - self.greenView.frame.size.height)) style:(UITableViewStylePlain)];
    [self.view addSubview:_newsTableView];
    [self.newsTableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"news"];
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
}

#pragma mark -- 将创建label封装为一个方法
- (UILabel *)labelLayoutWithx:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment fontSize:(CGFloat)size {
    UILabel *myLabel = [[UILabel alloc]initWithFrame:(CGRectMake(x, y, width, height))];
    myLabel.textColor = color;
    myLabel.textAlignment = textAlignment;
    myLabel.font = [UIFont systemFontOfSize:size];
    return myLabel;
}

#pragma mark -- pop回上一控制器
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 下方新闻
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news" forIndexPath:indexPath];
    NewsModel * nModel = self.allDataArray[indexPath.row];
    [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:nModel.pic_small] placeholderImage:[UIImage imageNamed:@""] options:0];
    cell.titleLabel.text = nModel.title;
    cell.contentLabel.text = nModel.summary;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel * nModel = self.allDataArray[indexPath.row];
    NewsContentViewController * ncVC = [[NewsContentViewController alloc]init];
    ncVC.myId = nModel.newsId;
    [self.navigationController pushViewController:ncVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
