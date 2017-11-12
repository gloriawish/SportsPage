//
//  SPProtocolViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPProtocolViewController.h"

@interface SPProtocolViewController ()

@end

@implementation SPProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*4083/220)];
    imageView.image = [UIImage imageNamed:@"protocol"];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*4083/220);
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
