//
//  FirstViewController.m
//  TitleSelectView
//
//  Created by zhanght on 16/4/30.
//  Copyright © 2016年 HT-SOFT. All rights reserved.
//

#import "FirstViewController.h"
#import "TitleSelectView.h"

@interface FirstViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) TitleSelectView *titleView;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleView = [[TitleSelectView alloc] initWithFrame:CGRectMake(0, 200, 196, 44)];
    [self.titleView setTitles:@[@"123", @"123", @"123"] selectHandler:^(NSInteger selectButtonIndex) {
       NSLog(@"--zhanght-- %ld", (long)selectButtonIndex);
    }];
    self.navigationItem.titleView = self.titleView;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    v.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:v];
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height)];
    v1.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:v1];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(2*screenSize.width, 0, screenSize.width, screenSize.height)];
    v2.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:v2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat progress = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    self.titleView.scrollProgress = progress;
}

@end
