//
//  MatchDataViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/29/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "MatchDataViewController.h"
#import "CSLViewController.h"
#import "EPLViewController.h"
#import "BBVAViewController.h"
#import "BUNDESViewController.h"
#import "Ligue1ViewController.h"
#import "SerieAViewController.h"
#import "CALViewController.h"

@interface MatchDataViewController () {
    CSLViewController * _CSLVC;
}

@end

@implementation MatchDataViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.487 green:0.863 blue:0.561 alpha:1.000];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _CSLVC = [[CSLViewController alloc]init];
    [self addChildViewController:_CSLVC];
    [self.view addSubview:_CSLVC.view];
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
