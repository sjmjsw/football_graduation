//
//  MatchViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/18/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "MatchViewController.h"
#import "PhotoTableViewCell.h"
#import "MatchTableViewCell.h"

@interface MatchViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    UITableView * _matchTableView;
    // 存放图片数据的数组
    NSMutableArray * _photoArray;
    // 存放赛事数组的数组
    NSMutableArray * _matchArray;
    // 存放时间的数组
    NSMutableArray * _timeArray;
}

@end

@implementation MatchViewController

- (void)loadView {
    _matchTableView = [[UITableView alloc]initWithFrame:mScreen_bounds style:(UITableViewStylePlain)];
    self.view = _matchTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _matchTableView.contentInset = UIEdgeInsetsMake(0, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 遵守代理
    _matchTableView.delegate = self;
    _matchTableView.dataSource = self;
    _matchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [_matchTableView registerNib:[UINib nibWithNibName:@"PhotoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"photo"];
    [_matchTableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"match"];
    // 初始化数组
    _photoArray = [NSMutableArray array];
    _matchArray = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    // 加载比赛数据
    [[ConnectManager sharedManager] getDataWithURL:@"http://kapi.zucaitong.com/match/recommendedv2" params:nil success:^(id responseObj) {
        if (responseObj) {
            // NSLog(@"%@", responseObj);
            _timeArray = responseObj[@"data"];
            NSDictionary * dict = _timeArray.firstObject;
            NSString * firMatch_time = dict[@"match_time"];
            NSDate * firDate = [[NSDate alloc]initWithTimeIntervalSince1970:firMatch_time.integerValue];
            // NSLog(@"date:%@", firDate);
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString * timeStr = [formatter stringFromDate:firDate];
            NSMutableArray * tempArray = [NSMutableArray array];
            for (NSDictionary * dic in _timeArray) {
                NSString * match_time = dic[@"match_time"];
                
                NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:match_time.integerValue];
                // NSLog(@"date:%@", date);
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd";
                NSString * dateString = [formatter stringFromDate:date];
                if (![timeStr isEqualToString:dateString]) {
                    [_matchArray addObject:tempArray];
                    tempArray = [NSMutableArray array];
                    timeStr = dateString;
                }
                [tempArray addObject:dic];
            }
            [_matchTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    UIFont * font = [UIFont fontWithName:@"Palatino-Roman" size:14.0f];
    NSDictionary * attrsDictionary = @{NSFontAttributeName : font};
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _matchArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return [_matchArray[section - 1] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return mScreen_bounds.size.height / 2.5;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * photoCellIndentifier = @"photo";
        PhotoTableViewCell * photoCell = [tableView dequeueReusableCellWithIdentifier:photoCellIndentifier forIndexPath:indexPath];
        if (photoCell == nil) {
            photoCell = [[PhotoTableViewCell alloc]init];
        }
        photoCell.photoScrollView.delegate = self;
        [self photoScrollView:photoCell.photoScrollView];
        photoCell.photoScrollView.showsVerticalScrollIndicator = NO;
        photoCell.photoScrollView.showsHorizontalScrollIndicator = NO;
        [[ConnectManager sharedManager] getDataWithURL:@"http://kapi.zucaitong.com/ad/banner" params:nil success:^(id responseObj) {
            if (responseObj) {
                _photoArray = responseObj[@"data"];
                
                NSMutableArray * picArray = [NSMutableArray array];
                for (NSDictionary * dic in _photoArray) {
                    NSString * pic = dic[@"pic"];
                    [picArray addObject:pic];
                }
                
                if (_photoArray.count != 0) {
                    
                    photoCell.photoScrollView.contentSize = CGSizeMake(mScreen_bounds.size.width * (picArray.count + 1), photoCell.photoScrollView.contentSize.height);
                    
                    UIImageView * imageView0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreen_bounds.size.width, photoCell.photoScrollView.contentSize.height)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [imageView0 sd_setImageWithURL:[NSURL URLWithString:picArray[picArray.count - 2]] placeholderImage:[UIImage imageNamed:@""] options:0];
                    });
                    [photoCell.photoScrollView addSubview:imageView0];
//                    int i = 1;
//                    for (NSString * picStr in picArray) {
//                        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(mScreen_bounds.size.width * i, 0, mScreen_bounds.size.width, photoCell.photoScrollView.contentSize.height)];
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                            [imageView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@""] options:0];
//                        });
//                        [photoCell.photoScrollView addSubview:imageView];
//                        i++;
//                    }
                    NSInteger j = 1;
                    for (NSInteger i = 0; i < picArray.count - 1; i++) {
                        NSString * picStr = picArray[i];
                        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(mScreen_bounds.size.width * j, 0, mScreen_bounds.size.width, photoCell.photoScrollView.contentSize.height)];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [imageView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@""] options:0];
                        });
                        [photoCell.photoScrollView addSubview:imageView];
                        j++;
                    }
                    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(mScreen_bounds.size.width * j, 0, mScreen_bounds.size.width, photoCell.photoScrollView.contentSize.height)];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray.firstObject] placeholderImage:[UIImage imageNamed:@""] options:0];
                    });
                    [photoCell.photoScrollView addSubview:imageView1];
                }
            }
        } failure:^(NSError *error) {
            
        }];
        
        return photoCell;
    }else {
        static NSString * matchCellIndentifier = @"match";
        MatchTableViewCell * matchCell = [tableView dequeueReusableCellWithIdentifier:matchCellIndentifier forIndexPath:indexPath];
        if (matchCell == nil) {
            matchCell = [[MatchTableViewCell alloc]init];
        }
        NSDictionary * dict = _matchArray[indexPath.section - 1][indexPath.row];
        NSString * time = dict[@"match_time"];
        // NSLog(@"%ld", time.integerValue);
        NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:time.integerValue];
        // NSLog(@"date:%@", date);
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"HH:mm";
        NSString * dateString = [formatter stringFromDate:date];
        
        matchCell.timeLabel.text = dateString;
        NSDictionary * eventDic = dict[@"event"];
        matchCell.matchLabel.text = eventDic[@"name"];
        NSDictionary * teamDic = dict[@"team"];
        NSDictionary * homeDic = teamDic[@"home"];
        NSDictionary * awayDic = teamDic[@"away"];
        matchCell.homeTeamLabel.text = homeDic[@"name"];
        matchCell.awayTeamLabel.text = awayDic[@"name"];
        NSString * liveStr = [NSString string];
        for (NSString * str in dict[@"live"]) {
            liveStr = [NSString stringWithFormat:@"%@    %@", liveStr, str];
            // NSLog(@"%@", str);
        }
        matchCell.liveLabel.text = liveStr;
        matchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return matchCell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        NSDictionary * dateDic = [_matchArray[section - 1] firstObject];
        NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:[dateDic[@"match_time"] integerValue]];
        NSDateFormatter * df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd EEEE";
        NSString * headerTitle = [df stringFromDate:date];
        // NSLog(@"%@", headerTitle);
        return headerTitle;
    }else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        NSDictionary * dateDic = [_matchArray[section - 1] firstObject];
        NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:[dateDic[@"match_time"] integerValue]];
        NSDateFormatter * df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd EEEE";
        NSString * headerTitle = [df stringFromDate:date];
        // NSLog(@"%@", headerTitle);
        UILabel * label = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, mScreen_bounds.size.width, 20))];
        label.backgroundColor = [UIColor colorWithRed:0.603 green:0.834 blue:0.570 alpha:1.000];
        label.font = [UIFont systemFontOfSize:13];
        label.text = [NSString stringWithFormat:@"   %@", headerTitle];
        return label;
    }else {
        return nil;
    }
}

#pragma mark -- photoScrollView
- (void)photoScrollView:(UIScrollView *)scrollView {
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.contentOffset = CGPointMake(mScreen_bounds.size.width, 0);
}

#pragma mark -- scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 确定滑动的是scrollView而不是tableView
    if (scrollView.class == [UIScrollView class]) {
        if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - 2 * mScreen_bounds.size.width, 0);
            }
        if (scrollView.contentOffset.x == scrollView.contentSize.width - mScreen_bounds.size.width) {
            scrollView.contentOffset = CGPointMake(mScreen_bounds.size.width, 0);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
