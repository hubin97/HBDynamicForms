//
//  HBDFLocationCell.m
//  HLJWWNOP
//
//  Created by mastercom on 2018/3/22.
//  Copyright © 2018年 Mastercom. All rights reserved.
//

#import "HBDFLocationCell.h"

@interface HBDFLocationCell()<BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate>
{
    //gps
    double _localLng;
    double _localLat;
    
    //address
    BMKReverseGeoCodeSearchResult * _result;
}

@property (nonatomic, strong) BMKLocationManager *locManager; //定位

@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;
@property (nonatomic, strong) BMKReverseGeoCodeSearchOption *geoCodeOption;

@end

@implementation HBDFLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.flagImageVIew.hidden = YES;
    
    _lngTextField.delegate = self;
    _latTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)locationAction:(id)sender {
    //
    NSLog(@"locationAction---");
    
    [SVProgressHUD showWithStatus:@"正在获取定位..."];
    
    //启动LocationService
    [self.locManager startUpdatingLocation];
    
    //若10s内没获取到定位信息,则dismiss并提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //???:特殊情况,获取到了地理坐标,反编译失败(可能情况:申请的key的安全码与项目中的bundle id要不一致)
        [SVProgressHUD dismiss];
        
        if(_callBackGpsBlock && [_result.address length] == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"获取地理位置失败!"];
            
            _callBackGpsBlock(_localLng,_localLat,nil);
        }
    });
}

#pragma mark - Lazy loading
- (BMKLocationManager *)locManager {
    if (_locManager == nil) {
        _locManager = [[BMKLocationManager alloc]init];
        _locManager.delegate = self;
        _locManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.activityType = CLActivityTypeAutomotiveNavigation;
        _locManager.pausesLocationUpdatesAutomatically = NO;
        // YES的话是可以进行后台定位的，但需要项目配置，否则会报错，具体参考开发文档
        _locManager.allowsBackgroundLocationUpdates = NO;
        _locManager.locationTimeout = 10;
        _locManager.reGeocodeTimeout = 10;
    }
    return _locManager;
}

- (BMKGeoCodeSearch *)geoSearch {
    if (_geoSearch == nil) {
        _geoSearch = [[BMKGeoCodeSearch alloc]init];
        _geoSearch.delegate = self;
    }
    return _geoSearch;
}

- (BMKReverseGeoCodeSearchOption *)geoCodeOption {
    if (_geoCodeOption == nil) {
        _geoCodeOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    }
    return _geoCodeOption;
}

#pragma mark - BMKLocationManagerDelegate
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"didFailWithError---");
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error {
    NSLog(@"didUpdateLocation---");
    /**
     (lldb) po location.location.coordinate.latitude
     26.677874464676872
     
     (lldb) po location.location.coordinate.longitude
     113.01120262687425
     */
    
    _localLng = location.location.coordinate.longitude;
    _localLat = location.location.coordinate.latitude;
    
    NSLog(@"didUpdateLocation---%.2f %.2f", _localLat, _localLng);

    //发起逆地理编码检索请求
    self.geoCodeOption.location = location.location.coordinate;
    BOOL flag = [self.geoSearch reverseGeoCode:self.geoCodeOption];
    if (flag)
    {
        NSLog(@"逆geo检索发送成功");
        [self.locManager stopUpdatingLocation];
    }
    else
    {
        NSLog(@"逆geo检索发送失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetGeoCodeResult---result:%@", result);

}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetReverseGeoCodeResult---:%@", result.address);
    
     //反编译返回时才移除
    [SVProgressHUD dismiss];
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        NSLog(@"%@",result);
        
        _result = result;
        
        if(_callBackGpsBlock)
        {
            _callBackGpsBlock(_localLng,_localLat,result);
        }
    }
    else if (error == BMK_SEARCH_PERMISSION_UNFINISHED)
    {
        //
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"---textFieldDidEndEditing");
    
    _localLng = (textField == _lngTextField)? [_lngTextField.text doubleValue] : _localLng;
    _localLat = (textField == _latTextField)? [_latTextField.text doubleValue] : _localLat;

    if(_callBackGpsBlock)
    {
        _callBackGpsBlock(_localLng,_localLat,nil);
    }
}

// 正则限制输入 float 类型
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"^\\d*\\.{0,1}\\d*$" options:0 error:nil];
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    NSString* changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray* matches = [regEx matchesInString:changedString options:0 range:NSMakeRange(0, changedString.length)];
    return matches.count > 0;
}

@end
