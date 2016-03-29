//
//  NewsAndVideosViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/24/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "NewsAndVideosViewController.h"
#import "NewsTableViewController.h"
#import "VideosTableViewController.h"

@interface NewsAndVideosViewController () {
    NewsTableViewController * _newsVC;
    VideosTableViewController * _videosVC;
    UISegmentedControl * _segmentControl;
}

@end

@implementation NewsAndVideosViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.487 green:0.863 blue:0.561 alpha:1.000];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsVC = [[NewsTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    _videosVC = [[VideosTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _videosVC.tableView.contentInset = UIEdgeInsetsMake(-10, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    [self addChildViewController:_newsVC];
    [self addChildViewController:_videosVC];
    [self.view addSubview:_videosVC.tableView];
    [self.view addSubview:_newsVC.tableView];
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"新闻", @"视频"]];
    _segmentControl.frame = CGRectMake(mScreen_bounds.size.width / 2 - 90, 5, 180, 25);
    _segmentControl.tintColor = [UIColor blackColor];
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
    _segmentControl.selectedSegmentIndex = 0;
    [self.navigationController.navigationBar addSubview:_segmentControl];
    UISwipeGestureRecognizer * leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    UISwipeGestureRecognizer * rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)segmentAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self transitionFromViewController:_videosVC toViewController:_newsVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
            break;
        case 1:
            [self transitionFromViewController:_newsVC toViewController:_videosVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
            break;
        default:
            break;
    }
}

#pragma mark -- 手势方法
- (void)leftSwipeAction:(UISwipeGestureRecognizer *)gesture {
    if (_segmentControl.selectedSegmentIndex == 0) {
        [self transitionFromViewController:_newsVC toViewController:_videosVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        _segmentControl.selectedSegmentIndex = 1;
    }
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)gesture {
    if (_segmentControl.selectedSegmentIndex == 1) {
        [self transitionFromViewController:_videosVC toViewController:_newsVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        _segmentControl.selectedSegmentIndex = 0;
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
