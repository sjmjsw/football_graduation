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
    [[ConnectManager sharedManager] getDataWithURL:urlStr params:nil success:^(id responseObj) {
        if (responseObj) {
            NSDictionary * dict = responseObj[@"data"];
            self.titleLabel.text = dict[@"title"];
            self.sourceLabel.text = dict[@"source"];
            NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:[dict[@"publish_time"] integerValue]];
            NSDateFormatter * df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString * dateStr = [df stringFromDate:date];
            self.publish_timeLabel.text = dateStr;
            NSString * htmlStr = dict[@"body"];
            NSMutableAttributedString * mAttStr = [[NSMutableAttributedString alloc]initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
            [mAttStr beginEditing];
            NSRange range = NSMakeRange(0, 20);
            
            id ttt = [mAttStr attribute:NSFontAttributeName atIndex:0 effectiveRange:&range];
            NSLog(@"%@", ttt);
            
            self.myTextView.attributedText = mAttStr;
            self.myTextView.editable = NO;
        }
    } failure:^(NSError *error) {
        
    }];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"回去" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    backItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemAction:(UIBarButtonItem *)sender {
    NSArray * subViewArr = self.navigationController.navigationBar.subviews;
    for (UIView * view in subViewArr) {
        if (view.class == [UISegmentedControl class]) {
            view.hidden = NO;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
