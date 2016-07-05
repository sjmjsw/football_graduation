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

@interface NewsAndVideosViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) NewsTableViewController *newsVC;
@property (nonatomic, strong) VideosTableViewController *videosVC;
@end

@implementation NewsAndVideosViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.487 green:0.863 blue:0.561 alpha:1.000];
    self.segmentControl.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.segmentControl.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildAndSubView];
}

- (void)addChildAndSubView {
    [self addChildViewController:self.newsVC];
    [self addChildViewController:self.videosVC];
    [self.view addSubview:self.videosVC.tableView];
    [self.view addSubview:self.newsVC.tableView];
    [self.navigationController.navigationBar addSubview:self.segmentControl];
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
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self transitionFromViewController:_newsVC toViewController:_videosVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        self.segmentControl.selectedSegmentIndex = 1;
    }
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)gesture {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        [self transitionFromViewController:_videosVC toViewController:_newsVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        self.segmentControl.selectedSegmentIndex = 0;
    }
}

#pragma mark -- 懒加载
- (UISegmentedControl *)segmentControl {
    if (_segmentControl == nil) {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"新闻", @"视频"]];
        _segmentControl.frame = CGRectMake(mScreen_bounds.size.width / 2 - 90, 5, 180, 25);
        _segmentControl.tintColor = [UIColor blackColor];
        [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
        _segmentControl.selectedSegmentIndex = 0;
    }
    return _segmentControl;
}

- (NewsTableViewController *)newsVC {
    if (_newsVC == nil) {
        _newsVC = [[NewsTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    }
    return _newsVC;
}

- (VideosTableViewController *)videosVC {
    if (_videosVC == nil) {
        _videosVC = [[VideosTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
        self.edgesForExtendedLayout = UIRectEdgeAll;
        _videosVC.tableView.contentInset = UIEdgeInsetsMake(-10, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    }
    return _videosVC;
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
