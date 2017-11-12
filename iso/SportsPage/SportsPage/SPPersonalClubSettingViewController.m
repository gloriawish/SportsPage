//
//  SPPersonalClubSettingViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubSettingViewController.h"

//Header
#import "SPPersonalClubSettingHeaderView.h"

//Cell
#import "SPPersonalClubSettingTableViewCell.h"

//成员列表
#import "SPClubMembersListViewController.h"
//俱乐部资料页
#import "SPPersonalClubInfoViewController.h"
//加入俱乐部方式
#import "SPPersonalClubJoinWayViewController.h"

#import "SPUserInfoModel.h"

//添加俱乐部成员ViewController
#import "SPClubMembersAddNorViewController.h"

@interface SPPersonalClubSettingViewController () <UITableViewDelegate,UITableViewDataSource,SPPersonalClubSettingHeaderViewProtocol,SPPersonalClubJoinWayViewControllerProtocol,SPPersonalClubInfoViewControllerProtocol> {
    
    SPPersonalClubSettingViewControllerStyle _style;
    
    SPPersonalClubSettingHeaderView *_headerView;
    
    UIImage *_clubCoverImage;
    UIImage *_clubTeamImage;
    
    NSString *_clubName;
    NSString *_clubEvent;
    NSString *_clubExtend;
    NSString *_clubPublicNotice;
    NSString *_clubJoinType;
    
    NSMutableArray <SPUserInfoModel *>*_clubMembersArray;
    NSString *_clubMembersCount;
    
    NSString *_clubId;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalClubSettingViewController

- (instancetype)initWithViewControllerType:(SPPersonalClubSettingViewControllerStyle)style {
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    [self setUpTableView];
    [self setUpTableViewHeader];
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];;
    _tableView.tableFooterView = [UIView new];
}

- (void)setUpTableViewHeader {
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"SPPersonalClubSettingHeaderView" owner:nil options:nil] lastObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*137/375);
    [_headerView setUpMembersArray:_clubMembersArray
                 totalMembersCount:_clubMembersCount];
    _headerView.delegate = self;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*137/375)];
    [header addSubview:_headerView];
    _tableView.tableHeaderView = header;
    
}

- (void)setUpCoverImage:(UIImage *)coverImage
              teamImage:(UIImage *)teamImage
               clubName:(NSString *)clubName
              clubEvent:(NSString *)clubEvent
             clubExtend:(NSString *)clubExtend
       clubPublicNotice:(NSString *)clubPublicNotice
           clubJoinType:(NSString *)clubJoinType {
    
    _clubCoverImage = coverImage;
    _clubTeamImage = teamImage;
    
    _clubName = clubName;
    _clubEvent = clubEvent;
    _clubExtend = clubExtend;
    _clubPublicNotice = clubPublicNotice;
    _clubJoinType = clubJoinType;
    
}

- (void)setUpClubMembersArray:(NSMutableArray <SPUserInfoModel *>*)clubMembersArray
             clubMembersCount:(NSString *)clubMembersCount
                       clubId:(NSString *)clubId {
    _clubMembersArray = clubMembersArray;
    _clubMembersCount = clubMembersCount;
    _clubId = clubId;
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)clubSettingMoreAction:(UIButton *)sender {
    
    sender.userInteractionEnabled = false;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (_style == SPPersonalClubSettingViewControllerStyleAdmin) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出俱乐部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"退出俱乐部");
            sender.userInteractionEnabled = true;
        }];
        [alertController addAction:action];
        
    } else if (_style == SPPersonalClubSettingViewControllerStyleCreator) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"解散俱乐部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"解散俱乐部");
            sender.userInteractionEnabled = true;
        }];
        [alertController addAction:action];
        
    }
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        sender.userInteractionEnabled = true;
    }];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalClubSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalClubSettingTableViewCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalClubSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalClubSettingTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalClubSettingTableViewCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SPPersonalClubSettingTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell setUpStyle:SPPersonalClubSettingTableViewCellSyleInfo];
    } else if (indexPath.row == 1) {
        [cell setUpStyle:SPPersonalClubSettingTableViewCellSyleJoinClubWay];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SPPersonalClubInfoViewController *clubInfoViewController = [[SPPersonalClubInfoViewController alloc] init];
        clubInfoViewController.delegate = self;
        [clubInfoViewController setUpCoverImage:_clubCoverImage
                                      teamImage:_clubTeamImage
                                       clubName:_clubName
                                      clubEvent:_clubEvent
                                     clubExtend:_clubExtend
                               clubPublicNotice:_clubPublicNotice
                                         clubId:_clubId];
        [self.navigationController pushViewController:clubInfoViewController animated:true];
    } else if (indexPath.row == 1) {
        
        SPPersonalClubJoinWayStyle style = SPPersonalClubJoinWayStyleNoConfirm;
        
        if ([_clubJoinType isEqualToString:@"2"]) {
            style = SPPersonalClubJoinWayStyleHasConfirm;
        }
        
        SPPersonalClubJoinWayViewController *clubJoinWayViewController = [[SPPersonalClubJoinWayViewController alloc] initWithStyle:style clubId:_clubId];
        clubJoinWayViewController.delegate  = self;
        [self.navigationController pushViewController:clubJoinWayViewController animated:true];
    }
}

#pragma mark - SPPersonalClubSettingHeaderViewProtocol
- (void)clickClubViewAction {
    SPClubMembersListViewController *clubMembersListViewController = [[SPClubMembersListViewController alloc] init];
    [clubMembersListViewController setUpClubId:_clubId userIdentity:(SPClubMembersListViewControllerUserIdentity)_style];
    [self.navigationController pushViewController:clubMembersListViewController animated:true];
}

- (void)clickClubmembersImageViewAction {
    SPClubMembersAddNorViewController *addNorViewController = [[SPClubMembersAddNorViewController alloc] init];
    [addNorViewController setUpClubId:_clubId];
    [self.navigationController presentViewController:addNorViewController animated:true completion:nil];
}

#pragma mark - SPPersonalClubJoinWayViewControllerProtocol
- (void)updateJoinType:(SPPersonalClubJoinWayStyle)style {
    if (style == SPPersonalClubJoinWayStyleHasConfirm) {
        _clubJoinType = @"2";
    } else if (style == SPPersonalClubJoinWayStyleNoConfirm) {
        _clubJoinType = @"1";
    }
    
    if ([_delegate respondsToSelector:@selector(updateJoinType:)]) {
        [_delegate updateJoinType:_clubJoinType];
    }
}

#pragma mark - SPPersonalClubInfoViewControllerProtocol
- (void)updateClubCover:(UIImage *)coverImage {
    _clubCoverImage = coverImage;
    
    if ([_delegate respondsToSelector:@selector(updateClubCoverImage:)]) {
        [_delegate updateClubCoverImage:coverImage];
    }
    
}

- (void)updateClubTeamImage:(UIImage *)teamImage {
    _clubTeamImage = teamImage;
    
    if ([_delegate respondsToSelector:@selector(updateClubTeamImage:)]) {
        [_delegate updateClubTeamImage:teamImage];
    }

}

- (void)updateClubName:(NSString *)clubName {
    _clubName = clubName;
    
    if ([_delegate respondsToSelector:@selector(updateClubName:)]) {
        [_delegate updateClubName:clubName];
    }
    
}

- (void)updateClubEvent:(NSString *)clubEventNum clubEventString:(NSString *)clubEventString {
    _clubEvent = clubEventNum;
    
    if ([clubEventNum isEqualToString:@"20"]) {
        _clubExtend = clubEventString;
    } else {
        _clubExtend = nil;
    }
    
    if ([_delegate respondsToSelector:@selector(updateClubEvent:clubEventExtend:)]) {
        [_delegate updateClubEvent:clubEventNum clubEventExtend:_clubExtend];
    }
}

- (void)updateClubPublicNotice:(NSString *)clubPublicNotice {
    _clubPublicNotice = clubPublicNotice;
    
    if ([_delegate respondsToSelector:@selector(updateClubPublicNotice:)]) {
        [_delegate updateClubPublicNotice:clubPublicNotice];
    }
    
}

@end
