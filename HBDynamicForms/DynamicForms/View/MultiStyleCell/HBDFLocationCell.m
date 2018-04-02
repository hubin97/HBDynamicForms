//
//  HBDFLocationCell.m
//  HLJWWNOP
//
//  Created by mastercom on 2018/3/22.
//  Copyright © 2018年 Mastercom. All rights reserved.
//

#import "HBDFLocationCell.h"

@interface HBDFLocationCell()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate>
{
    //gps
    double _localLng;
    double _localLat;
    
    //address
    BMKReverseGeoCodeResult * _result;
}
@property (nonatomic, strong) BMKLocationService *locService; //定位
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;
@property (nonatomic, strong) BMKReverseGeoCodeOption *geoCodeOption;

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
    
    [SVProgressHUD showWithStatus:@"正在获取定位..." maskType:SVProgressHUDMaskTypeBlack];

    //启动LocationService
    [_locService startUserLocationService];
    
    //若10s内没获取到定位信息,则dismiss并提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(!_locService.userLocation.location)[SVProgressHUD showErrorWithStatus:@"获取定位失败!"];
        
        //???:特殊情况,获取到了地理坐标,反编译失败(可能情况:申请的key的安全码与项目中的bundle id要不一致)
        [SVProgressHUD dismiss];
        
        if(_callBackGpsBlock && [_result.address length] == 0)
        {
            _callBackGpsBlock(_localLng,_localLat,nil);
        }
    });
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
        _geoSearch = [[BMKGeoCodeSearch alloc]init];
        _geoSearch.delegate = self;
        _geoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    return self;
}


#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    _localLng = userLocation.location.coordinate.longitude;
    _localLat = userLocation.location.coordinate.latitude;
    
    [_geoCodeOption setReverseGeoPoint:userLocation.location.coordinate];
    
    //!!!!: 注意申请的key的安全码与项目中的bundle id要匹配一致,否则即使能定位经纬度,也会导致地理反编译失败
    BOOL ret = [_geoSearch reverseGeoCode:_geoCodeOption];
    
    if (ret)
    {
        NSLog(@"反编译成功!");
        //关闭定位服务
        [_locService stopUserLocationService];
    }
    else
    {
        NSLog(@"反编译失败!");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"onGetReverseGeoCodeResult:%@----------%@",result.address,result.businessCircle);
    
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

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"onGetGeoCodeResult:%@---%@-----%u",searcher,result,error);
}

#pragma mark - <UITextFieldDelegate>
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
