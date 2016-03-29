//
//  CSLViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/29/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "CSLViewController.h"
#import "MatchDataModel.h"
#import "MatchDataTableViewCell.h"

@interface CSLViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView * _CSLTableView;
    NSMutableArray * _allDataArray;
}

@end

@implementation CSLViewController

- (void)loadView {
    _CSLTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.view = _CSLTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _CSLTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _CSLTableView.delegate = self;
    _CSLTableView.dataSource = self;
    [_CSLTableView registerNib:[UINib nibWithNibName:@"MatchDataTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"csl"];
    _allDataArray = [NSMutableArray array];
    [[ConnectManager sharedManager] getDataWithURL:@"http://kapi.zucaitong.com/event/score?id=364&season=2016" params:nil success:^(id responseObj) {
        if (responseObj) {
            
            NSArray * dataArr = responseObj[@"data"];
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
                [_allDataArray addObject:mdModel];
            }
            [_CSLTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    _CSLTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"csl"];
    MatchDataModel * mdModel = _allDataArray[indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
