//
//  SPBootViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/21.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBootViewController.h"
//#import "SPLoginWayViewController.h"
#import "SPLoginViewController.h"

#define PageNum 3

@interface SPBootViewController () <UIScrollViewDelegate> {
    UIScrollView *_bootScrollView;
    UIPageControl *_pageControl;
}

@end

@implementation SPBootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUp {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    _bootScrollView.delegate = self;
    _bootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*PageNum, 0);
    _bootScrollView.bounces = false;
    _bootScrollView.showsHorizontalScrollIndicator = false;
    _bootScrollView.pagingEnabled = true;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor redColor];
    [self.view addSubview:backView];
    
    NSArray *imageNameArray = @[@"boot_imageView_1",@"boot_imageView_2",@"boot_imageView_3"];
    
    for (int i=0; i<PageNum; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //imageView.backgroundColor = [SPGlobalConfig anyColorWithRed:arc4random()%255 green:arc4random()%255 blue:arc4random()%255 alpha:1];
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        imageView.tag = i+1;
        [_bootScrollView addSubview:imageView];
    }
    
    [backView addSubview:_bootScrollView];
    
    if (!_isMine) {
        UIView *lastView = [_bootScrollView viewWithTag:PageNum];
        lastView.userInteractionEnabled = true;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, SCREEN_HEIGHT*5/6+30, SCREEN_WIDTH-100, 35);
        [button setTitle:@"进入运动页" forState:UIControlStateNormal];
        [button setBackgroundColor:[SPGlobalConfig anyColorWithRed:245 green:245 blue:245 alpha:1]];
        button.layer.cornerRadius = 17.5;
        button.layer.masksToBounds = true;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(finishedBootAction:) forControlEvents:UIControlEventTouchUpInside];
        [lastView addSubview:button];
    } else {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 39, 50, 25);
        [backButton setBackgroundImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:backButton];
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-50, 80, 40)];
    _pageControl.numberOfPages = PageNum;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [backView addSubview:_pageControl];
}

- (void)finishedBootAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isAweakBoot"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //SPLoginWayViewController *loginWayViewController = [[SPLoginWayViewController alloc] init];
    SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:true];
    
}

- (void)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xPosition = scrollView.contentOffset.x;
    if (xPosition >= 0 && xPosition < SCREEN_WIDTH) {
        _pageControl.currentPage = 0;
    } else if (xPosition >= SCREEN_WIDTH && xPosition < SCREEN_WIDTH*2) {
        _pageControl.currentPage = 1;
    } else if (xPosition >= SCREEN_WIDTH*2 && xPosition < SCREEN_WIDTH*3) {
        _pageControl.currentPage = 2;
    }
}

@end
