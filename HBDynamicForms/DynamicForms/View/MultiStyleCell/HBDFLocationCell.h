//
//  HBDFLocationCell.h
//  HLJWWNOP
//
//  Created by mastercom on 2018/3/22.
//  Copyright © 2018年 Mastercom. All rights reserved.
//

#import <UIKit/UIKit.h>

// 参考: https://www.jianshu.com/p/0a8e5f54d95d
@interface HBDFLocationCell : UITableViewCell

/// 回调定位经纬度以及反编译地理位置信息
@property (nonatomic, copy) void (^callBackGpsBlock)(double lng, double lat,BMKReverseGeoCodeSearchResult *result);

// 标识是否必填
@property (weak, nonatomic) IBOutlet UIImageView *flagImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *lngTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *latTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UITextField *lngTextField;
@property (weak, nonatomic) IBOutlet UITextField *latTextField;

- (IBAction)locationAction:(id)sender;

@end
