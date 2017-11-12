//
//  SPCreateLocationViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateLocationViewController.h"

#import "SPSportBusinessUnit.h"
#import "SPSportsCreateLocationModel.h"
#import "SPSportsCreateLocationResponseModel.h"
#import "SPSportsCreateLocationTableViewCell.h"
#import "AppDelegate.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <MapKit/MKGeometry.h>

#import "MBProgressHUD.h"

#import "SPCreateLocationView.h"

#define Key_City @"上海"

@interface SPCreateLocationViewController () <BMKMapViewDelegate,BMKSuggestionSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    BMKMapView *_mapView;
    BMKPointAnnotation *_annotation;
    BMKSuggestionSearch *_suggestionSearch;
    BMKGeoCodeSearch *_geoSearch;
    
    SPCreateLocationView *_locationView;
    SPSportsCreateLocationResponseModel *_selectedModel;
    
    NSMutableArray <SPSportsCreateLocationResponseModel *>*_dataArray;

    NSString *_latitudeStr;
    NSString *_longitudeStr;
    
    NSString *_tempAddress;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *backMapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPCreateLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _suggestionSearch.delegate = nil;
    _geoSearch.delegate = nil;
}

#pragma mark -SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;

    _longitudeStr = @"";
    _latitudeStr = @"";
    
    [self setUpMap];
    [self setUpBar];
    [self setUpTableView];
}

- (void)setUpMap {
    _backMapView.userInteractionEnabled = true;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    [_backMapView addSubview:_mapView];
    
    _annotation = [[BMKPointAnnotation alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    double longitude = appDelegate.longitude;
    double latitude = appDelegate.latitude;
    
    if (longitude != 999 && latitude != 999) {
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        BMKCoordinateSpan coordinateSpan = BMKCoordinateSpanMake(0.01,0.01);
        [_mapView setCenterCoordinate:locationCoordinate animated:true];
        [_mapView setRegion:BMKCoordinateRegionMake([SPGlobalConfig changeCOMMONCoordinateToBaidu:locationCoordinate],coordinateSpan) animated:true];
    }
    
}

- (void)setUpBar {
    _searchBar.delegate = self;
}

- (void)setUpTableView {
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - BMKSuggestionSearchDelegate
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int i=0; i<result.keyList.count; i++) {
            SPSportsCreateLocationResponseModel *model = [[SPSportsCreateLocationResponseModel alloc] init];
            model.city = Key_City;
            NSString *addressString = [NSString stringWithFormat:@"%@%@%@",result.cityList[i],result.districtList[i],result.keyList[i]];
            model.address = addressString;
            CLLocationCoordinate2D location = [result.ptList[i] MKCoordinateValue];
            model.latitude = [NSString stringWithFormat:@"%lf",location.latitude];
            model.longitude = [NSString stringWithFormat:@"%lf",location.longitude];
            [tempArray addObject:model];
        }
        [_dataArray addObjectsFromArray:tempArray];
        [_tableView reloadData];
    } else {
        NSLog(@"未找到结果");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
                
        BMKAddressComponent *detail = result.addressDetail;
        _selectedModel.address = [NSString stringWithFormat:@"%@%@%@%@",detail.city,detail.district,detail.streetName,detail.streetNumber];
        if (_selectedModel.address.length == 0) {
            //_selectedModel.address = @"还没有详细地址";
            _selectedModel.address = _tempAddress;
        }
        [_locationView setUpWithModel:_selectedModel];
        [UIView animateWithDuration:0.3 animations:^{
            _windowImageView.alpha = 1;
            _locationView.selectedLocationView.alpha = 1;
            _locationView.createLocationViewController = self;
            _locationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        
    } else {
        NSLog(@"抱歉，未找到结果");
        [_locationView setUpWithModel:_selectedModel];
        [UIView animateWithDuration:0.3 animations:^{
            _windowImageView.alpha = 1;
            _locationView.selectedLocationView.alpha = 1;
            _locationView.createLocationViewController = self;
            _locationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsCreateLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateLocationCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPSportsCreateLocationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateLocationCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CreateLocationCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPSportsCreateLocationTableViewCell *)cell setUpWithPlaceName:_dataArray[indexPath.row].name address:_dataArray[indexPath.row].address];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
        return;
    }

    _selectedModel = _dataArray[indexPath.row];
    
    if (!_windowImageView) {
        _windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _windowImageView.image = [UIImage imageNamed:@"Sports_create_windowBG"];
        _windowImageView.alpha = 0;
    }
    [self.view addSubview:_windowImageView];
    
    _locationView = [[[NSBundle mainBundle] loadNibNamed:@"SPCreateLocationView" owner:nil options:nil] lastObject];
    _locationView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_locationView];
    
    //发起Geo反编码
    if (_selectedModel.name.length == 0 || !_selectedModel.name) {
        //发起反向地理编码检索
        CLLocationCoordinate2D point = (CLLocationCoordinate2D){[_selectedModel.latitude doubleValue], [_selectedModel.longitude doubleValue]};
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeSearchOption.reverseGeoPoint = point;
        _geoSearch = [[BMKGeoCodeSearch alloc]init];
        _geoSearch.delegate = self;
        BOOL flag = [_geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag) {
            _tempAddress = _selectedModel.address;
            NSLog(@"反geo检索发送成功");
        } else {
            NSLog(@"反geo检索发送失败");
            [_locationView setUpWithModel:_selectedModel];
            [UIView animateWithDuration:0.3 animations:^{
                _windowImageView.alpha = 1;
                _locationView.selectedLocationView.alpha = 1;
                _locationView.createLocationViewController = self;
                _locationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
        }
    } else {
        [_locationView setUpWithModel:_selectedModel];
        [UIView animateWithDuration:0.3 animations:^{
            _windowImageView.alpha = 1;
            _locationView.selectedLocationView.alpha = 1;
            _locationView.createLocationViewController = self;
            _locationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
    
    _latitudeStr = _dataArray[indexPath.row].latitude;
    _longitudeStr = _dataArray[indexPath.row].longitude;
    
    if ([_longitudeStr intValue] == 0 && [_latitudeStr intValue] == 0) {
        if (_annotation) {
            [_mapView removeAnnotation:_annotation];
        }
        return;
    }
    
    if (_annotation) {
        if ([_latitudeStr doubleValue] == _annotation.coordinate.latitude
        && [_longitudeStr doubleValue] == _annotation.coordinate.longitude) {
            return;
        } else {
            [_mapView removeAnnotation:_annotation];
        }
    }

    CLLocationCoordinate2D locationCoor = CLLocationCoordinate2DMake([_latitudeStr doubleValue], [_longitudeStr doubleValue]);
    _annotation.title = _searchBar.text;
    _annotation.coordinate = locationCoor;
    [_mapView addAnnotation:_annotation];
    [_mapView setCenterCoordinate:locationCoor animated:true];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = true;
    return true;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = false;
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    if (searchBar == _searchBar) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPSportBusinessUnit shareInstance] searchPlaceWithUserId:userId search:_searchBar.text city:Key_City successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                _dataArray = [(SPSportsCreateLocationModel *)jsonModel data];
                [_tableView reloadData];
                
                [self searchAction];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"searchPlace AFN ERROR:%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark Search
- (void)searchAction {
    _suggestionSearch = [[BMKSuggestionSearch alloc]init];
    _suggestionSearch.delegate = self;
    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = Key_City;
    option.keyword  = _searchBar.text;
    BOOL flag = [_suggestionSearch suggestionSearch:option];
    if(flag) {
        NSLog(@"建议检索发送成功");
    } else {
        NSLog(@"建议检索发送失败");
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
