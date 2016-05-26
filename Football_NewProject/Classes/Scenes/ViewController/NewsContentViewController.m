//
//  NewsContentViewController.m
//  Football_NewProject
//
//  Created by Guitar on 3/25/16.
//  Copyright © 2016 maleGod. All rights reserved.
//

#import "NewsContentViewController.h"

@interface NewsContentViewController ()

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
    self.navigationController.navigationBar.translucent = NO;
    NSString * urlStr = [NSString stringWithFormat:@"http://kapi.zucaitong.com/news/detail?id=%@", self.myId];
    [self connectToGainDataWithURL:urlStr];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"回去" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    backItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connectToGainDataWithURL:(NSString *)url {
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
            // 为了获取字符串长度和位置，更变字体
            NSString * title = dict[@"title"];
            NSString * source = dict[@"source"];
            NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:[dict[@"publish_time"] integerValue]];
            NSDateFormatter * df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy-MM-dd";
            NSString * dateStr = [df stringFromDate:date];
            weakSelf.publish_timeLabel.text = dateStr;
            NSRange titleRange = NSMakeRange(0, title.length);
            NSLog(@"%@, %lu", mAttStr, mAttStr.length);
            [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0f] range:titleRange];
            NSRange sourceRange = NSMakeRange(title.length + 1, title.length + source.length + dateStr.length);
            [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:sourceRange];
            NSRange contentRange = NSMakeRange(title.length + source.length + dateStr.length + 1, mAttStr.string.length - title.length - source.length - dateStr.length - 1);
            [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:contentRange];
            weakSelf.myTextView.attributedText = mAttStr;
            weakSelf.myTextView.editable = NO;
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
