//
//  NewsTableViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/24/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "NewsContentViewController.h"
#import "MJRefresh.h"

@interface NewsTableViewController () {
    NSInteger _myPage;
    // 菊花
    UIActivityIndicatorView * _indicatorView;
}
@property (nonatomic, strong) NSMutableArray *allDataArray;
@end

@implementation NewsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"news"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 刷新小菊花
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 130, 100, 100);
    _indicatorView.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:_indicatorView];
    // 请求数据
    _myPage = 1;
    [self connectToGainDataWithPage:1];
    // 下拉刷新
    [self headerRefresh];
    // 上拉加载
    [self footerRefresh];
}

- (void)connectToGainDataWithPage:(NSInteger)page {
    [_indicatorView startAnimating];
    __weak typeof(self)weakSelf = self;
    [[ConnectManager sharedManager] getDataWithURL:[NSString stringWithFormat:@"http://kapi.zucaitong.com/news?last_id=0&page_size=%ld&type=1", 20 * page] params:nil success:^(id responseObj) {
        if (responseObj) {
            self.allDataArray = [NSMutableArray array];
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
            [self.tableView reloadData];
            [_indicatorView stopAnimating];
            [_indicatorView setHidesWhenStopped:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)headerRefresh {
    __weak UITableView * tableView = self.tableView;
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_indicatorView startAnimating];
        _myPage = 1;
        [self connectToGainDataWithPage:1];
        // 结束刷新
        [tableView.header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.automaticallyChangeAlpha = YES;
}

- (void)footerRefresh {
    __weak UITableView * tableView = self.tableView;
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_indicatorView startAnimating];
        _myPage += 1;
        [self connectToGainDataWithPage:_myPage];
        if (_myPage == 5) {
            [tableView.footer endRefreshingWithNoMoreData];
        }else {
            [tableView.footer endRefreshing];
        }
    }];
}

#pragma mark - Table view data source

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 懒加载
- (NSMutableArray *)allDataArray {
    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
