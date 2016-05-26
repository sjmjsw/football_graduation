//
//  VideosTableViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/24/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "VideosTableViewController.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"

@interface VideosTableViewController ()
@property (nonatomic, strong) NSMutableArray *allDataArray;

@end

@implementation VideosTableViewController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"news"];
    __weak typeof(self)weakSelf = self;
    [[ConnectManager sharedManager] getDataWithURL:@"http://kapi.zucaitong.com/news?last_id=0&page_size=20&type=2" params:nil success:^(id responseObj) {
        if (responseObj) {
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
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
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
