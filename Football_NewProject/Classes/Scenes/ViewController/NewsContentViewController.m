//
//  NewsContentViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/25/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "NewsContentViewController.h"

@interface NewsContentViewController () {
    UIActivityIndicatorView * _indicatorView;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *publish_timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end

@implementation NewsContentViewController

- (void)viewWillAppear:(BOOL)animated {
    NSArray * subViewArr = self.navigationController.navigationBar.subviews;
    for (UIView * view in subViewArr) {
        if (view.class == [UISegmentedControl class]) {
            view.hidden = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 刷新小菊花
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 130, 100, 100);
    _indicatorView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_indicatorView];
    self.navigationController.navigationBar.translucent = NO;
    NSString * urlStr = [NSString stringWithFormat:@"http://kapi.zucaitong.com/news/detail?id=%@", self.myId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self connectToGainDataWithURL:urlStr];
    });
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"回去" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    backItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    [_indicatorView stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connectToGainDataWithURL:(NSString *)url {
    [_indicatorView startAnimating];
    __weak typeof(self)weakSelf = self;
    [[ConnectManager sharedManager] getDataWithURL:url params:nil success:^(id responseObj) {
        if (responseObj) {
            weakSelf.myTextView.editable = YES;
            NSDictionary * dict = responseObj[@"data"];
            weakSelf.titleLabel.text = dict[@"title"];
            weakSelf.sourceLabel.text = dict[@"source"];
            NSString * htmlStr = dict[@"body"];
            NSMutableAttributedString * mAttStr = [[NSMutableAttributedString alloc]initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
            [mAttStr beginEditing];
            
            NSArray *titleArray = [mAttStr.description componentsSeparatedByString:@"{"];
            // 更改标题的字体
            NSRange titleRange = NSMakeRange(0, [titleArray.firstObject length]);
            NSLog(@"%@, %lu", mAttStr, mAttStr.length);
            [mAttStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"TrebuchetMS" size:25.0f] range:titleRange];
            // 更改内容的字体
            NSRange sourceRange = NSMakeRange([titleArray.firstObject length], mAttStr.length - [titleArray.firstObject length]);
            [mAttStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f] range:sourceRange];
            
            weakSelf.myTextView.attributedText = mAttStr;
            weakSelf.myTextView.editable = NO;
            [_indicatorView stopAnimating];
        }
    } failure:^(NSError *error) {
        
    }];
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
