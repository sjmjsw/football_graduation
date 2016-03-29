//
//  TabBarController.m
//  Football_NewProject
//
//  Created by Guitar on 3/18/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "TabBarController.h"
#import "MatchViewController.h"
#import "NewsAndVideosViewController.h"
#import "MatchDataViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MatchViewController * matchVC = [[MatchViewController alloc]init];
    matchVC.title = @"首页";
    NewsAndVideosViewController * nvVC = [[NewsAndVideosViewController alloc]init];
    nvVC.title = @"新闻";
    MatchDataViewController * mdVC = [[MatchDataViewController alloc]init];
    mdVC.title = @"积分榜";
    self.viewControllers = @[matchVC, nvVC, mdVC];
    self.tabBar.tintColor = [UIColor colorWithRed:0.512 green:0.920 blue:0.549 alpha:1.000];
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
