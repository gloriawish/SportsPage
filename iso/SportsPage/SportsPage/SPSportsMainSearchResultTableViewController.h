//
//  SPSportsMainSearchResultTableViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/14.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPSportsMainSearchResultProtocol <NSObject>
- (void)searchResultTurnToNextPageWithEventId:(NSString *)eventId;
@end

@interface SPSportsMainSearchResultTableViewController : UITableViewController

@property (nonatomic,weak) id<SPSportsMainSearchResultProtocol> delegate;
@property (nonatomic,strong) NSMutableArray *searchResultsArray;

- (void)searchResultEndAction;
- (void)searchEventWithSearchKey:(NSString *)searchKey;

@end
