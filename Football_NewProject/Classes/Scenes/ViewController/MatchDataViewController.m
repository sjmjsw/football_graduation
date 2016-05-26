//
//  CSLViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/29/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "MatchDataViewController.h"
#import "MatchDataModel.h"
#import "MatchDataTableViewCell.h"
#import "ReachabilityManager.h"

@interface MatchDataViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *dataTableView;
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) FMDatabase *dateBase;
@property (nonatomic, assign) BOOL havingNet;
@end

@implementation MatchDataViewController

- (void)loadView {
    self.view = self.dataTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    _segmentControl.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.487 green:0.863 blue:0.561 alpha:1.000];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.dataTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
}

- (void)viewWillDisappear:(BOOL)animated {
    _segmentControl.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.dateBase open]) {
        NSLog(@"%s__%d__| 数据库打开成功", __FUNCTION__, __LINE__);
        BOOL result = [self.dateBase executeUpdate:@"create table if not exists MatchData (matchName text, myId text, name text, pic text, ranking text, played text, win text, draw text, lose text, goal text, otherGoal text, integral text)"];
        if (result) {
            NSLog(@"%s__%d__| 建表成功", __FUNCTION__, __LINE__);
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChangeNO) name:@"NetworkStatusIsNo" object:nil];
    
    if ([ReachabilityManager sharedManager].havingNet == NO) {
        [self myAlert];
    }
    
    [self searchDataWithName:@"中超" type:@"CN" matchId:@"364"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    [self.dataTableView registerNib:[UINib nibWithNibName:@"MatchDataTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"csl"];
    [self addSubviewAndGesture];
}

#pragma mark -- 添加子视图和手势
- (void)addSubviewAndGesture {
    [self.navigationController.navigationBar addSubview:self.segmentControl];
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.dataTableView addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.dataTableView addGestureRecognizer:swipeRight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"csl"];
    cell.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    MatchDataModel * mdModel = self.allDataArray[indexPath.row];
    cell.ranking.text = mdModel.ranking;
    cell.teamName.text = mdModel.name;
    cell.played.text = mdModel.played;
    cell.win.text = mdModel.win;
    cell.draw.text = mdModel.draw;
    cell.lose.text = mdModel.lose;
    cell.goalAndOtherGoal.text = [NSString stringWithFormat:@"%@/%@", mdModel.goal, mdModel.otherGoal];
    cell.integral.text = mdModel.integral;
    [cell.teamPic sd_setImageWithURL:[NSURL URLWithString:mdModel.pic]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, 20))];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:[self subviewLabelWithFrame:CGRectMake(10, 0, 100, 20) text:@"球队"]];
    [headerView addSubview:[self subviewLabelWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 32, 0, 30, 20) text:@"积分"]];
    [headerView addSubview:[self subviewLabelWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 50, 20) text:@"进/失"]];
    [headerView addSubview:[self subviewLabelWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 0, 30, 20) text:@"负"]];
    [headerView addSubview:[self subviewLabelWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 146, 0, 30, 20) text:@"平"]];
    [headerView addSubview:[self subviewLabelWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 182, 0, 30, 20) text:@"胜"]];
    [headerView addSubview:[self subviewLabelWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 216, 0, 30, 20) text:@"赛"]];
    return headerView;
}

- (UILabel *)subviewLabelWithFrame:(CGRect)rect text:(NSString *)test {
    UILabel * myLabel = [[UILabel alloc]initWithFrame:rect];
    myLabel.text = test;
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.font = [UIFont systemFontOfSize:13.0f];
    return myLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)segmentedControlAction:(UISegmentedControl *)value {
    switch (value.selectedSegmentIndex) {
        case 0:
            [self searchDataWithName:@"中超" type:@"CN" matchId:@"364"];
            break;
        case 1:
            [self searchDataWithName:@"英超" type:@"EN" matchId:@"1"];
            break;
        case 2:
            [self searchDataWithName:@"德甲" type:@"EN" matchId:@"52"];
            break;
        case 3:
            [self searchDataWithName:@"西甲" type:@"EN" matchId:@"43"];
            break;
        case 4:
            [self searchDataWithName:@"法甲" type:@"EN" matchId:@"65"];
            break;
        case 5:
            [self searchDataWithName:@"意甲" type:@"EN" matchId:@"27"];
            break;
        case 6:
            [self searchDataWithName:@"中甲" type:@"CN" matchId:@"365"];
            break;
        default:
            break;
    }
}

#pragma mark -- 从数据库中找数据
- (void)searchDataWithName:(NSString *)name type:(NSString *)type matchId:(NSString *)matchId {
    NSInteger count = [self.dateBase intForQuery:@"select count(*) from MatchData where matchName = ?", name];
    if (count != 0 && [ReachabilityManager sharedManager].havingNet == NO) {
        [self.allDataArray removeAllObjects];
        FMResultSet * set = [self.dateBase executeQuery:@"select * from MatchData where matchName = ?", name];
        while ([set next]) {
            MatchDataModel * mdModel = [[MatchDataModel alloc]init];
            [mdModel setValue:[set stringForColumn:@"myId"] forKey:@"myId"];
            [mdModel setValue:[set stringForColumn:@"name"] forKey:@"name"];
            [mdModel setValue:[set stringForColumn:@"pic"] forKey:@"pic"];
            [mdModel setValue:[set stringForColumn:@"ranking"] forKey:@"ranking"];
            [mdModel setValue:[set stringForColumn:@"played"] forKey:@"played"];
            [mdModel setValue:[set stringForColumn:@"win"] forKey:@"win"];
            [mdModel setValue:[set stringForColumn:@"draw"] forKey:@"draw"];
            [mdModel setValue:[set stringForColumn:@"lose"] forKey:@"lose"];
            [mdModel setValue:[set stringForColumn:@"goal"] forKey:@"goal"];
            [mdModel setValue:[set stringForColumn:@"otherGoal"] forKey:@"otherGoal"];
            [mdModel setValue:[set stringForColumn:@"integral"] forKey:@"integral"];
            [self.allDataArray addObject:mdModel];
        }
        [self.dataTableView reloadData];
        [self.dataTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if ([ReachabilityManager sharedManager].havingNet == YES) {
        // 请求数据
        [self connectWithURL:matchId type:type name:name];
    }else {
        [self myAlert];
    }
}

#pragma mark -- 请求数据
- (void)connectWithURL:(NSString *)matchId type:(NSString *)type name:(NSString *)name{
    NSString * urlStr = nil;
    if ([type isEqualToString:@"CN"]) {
        urlStr = [NSString stringWithFormat:@"http://kapi.zucaitong.com/event/score?id=%@&season=2016", matchId];
    }else if ([type isEqualToString:@"EN"]) {
        urlStr = [NSString stringWithFormat:@"http://kapi.zucaitong.com/event/score?id=%@&season=2015-2016", matchId];
    }
    __weak typeof(self)weakSelf = self;
    [[ConnectManager sharedManager] getDataWithURL:urlStr params:nil success:^(id responseObj) {
        if (responseObj) {
            [self.allDataArray removeAllObjects];
            NSArray * dataArr = responseObj[@"data"];
            BOOL deleteResult = [self.dateBase executeUpdate:@"delete from MatchData where matchName = ?", name];
            if (deleteResult) {
                NSLog(@"%s__%d__| 数据删除成功", __FUNCTION__, __LINE__);
            }
            for (NSArray * arr in dataArr) {
                MatchDataModel * mdModel = [[MatchDataModel alloc]init];
                [mdModel setValue:arr[0] forKey:@"myId"];
                [mdModel setValue:arr[1] forKey:@"name"];
                [mdModel setValue:arr[2] forKey:@"pic"];
                [mdModel setValue:arr[3] forKey:@"ranking"];
                [mdModel setValue:arr[4] forKey:@"played"];
                [mdModel setValue:arr[5] forKey:@"win"];
                [mdModel setValue:arr[6] forKey:@"draw"];
                [mdModel setValue:arr[7] forKey:@"lose"];
                [mdModel setValue:arr[8] forKey:@"goal"];
                [mdModel setValue:arr[9] forKey:@"otherGoal"];
                [mdModel setValue:arr[10] forKey:@"integral"];
                [weakSelf.allDataArray addObject:mdModel];
                BOOL insertResult = [self.dateBase executeUpdate:@"insert into MatchData (matchName, myId, name, pic, ranking, played, win, draw, lose, goal, otherGoal, integral) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", name, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7], arr[8], arr[9], arr[10]];
                if (insertResult) {
                    NSLog(@"%s__%d__| 数据插入成功", __FUNCTION__, __LINE__);
                }
            }
            [weakSelf.dataTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    [weakSelf.dataTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)leftAction:(UISwipeGestureRecognizer *)gesture {
    if (_segmentControl.selectedSegmentIndex < 6) {
        _segmentControl.selectedSegmentIndex += 1;
        [self segmentedControlAction:_segmentControl];
    }
}

- (void)rightAction:(UISwipeGestureRecognizer *)gesture {
    if (_segmentControl.selectedSegmentIndex > 0) {
        _segmentControl.selectedSegmentIndex -= 1;
        [self segmentedControlAction:_segmentControl];
    }
}

- (void)networkStatusChangeNO {
    [self myAlert];
}

#pragma mark -- alert
- (void)myAlert {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"没网了" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleDefault) handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 懒加载
- (UITableView *)dataTableView {
    if (_dataTableView == nil) {
        _dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame) - 25) style:(UITableViewStylePlain)];
    }
    return _dataTableView;
}

- (NSMutableArray *)allDataArray {
    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (UISegmentedControl *)segmentControl {
    if (_segmentControl == nil) {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"中超", @"英超", @"德甲", @"西甲", @"法甲", @"意甲", @"中甲"]];
        _segmentControl.frame = CGRectMake(20, 7, [UIScreen mainScreen].bounds.size.width - 40, 25);
        [_segmentControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:(UIControlEventValueChanged)];
        _segmentControl.tintColor = [UIColor blackColor];
        _segmentControl.selectedSegmentIndex = 0;
    }
    return _segmentControl;
}

- (FMDatabase *)dateBase {
    if (_dateBase == nil) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"matchData.sqlite"];
        NSLog(@"%@", filePath);
        _dateBase = [[FMDatabase alloc]initWithPath:filePath];
    }
    return _dateBase;
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
