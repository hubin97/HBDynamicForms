//
//  MTDateAndTimePickerView.h
//  WorkOrderManagement
//
//  Created by MasterCom on 2017/6/5.
//  Copyright © 2017年 MasterCom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDateAndTimePickerView : UIView


/**
 回调选择的时间字串
 */
@property (nonatomic, copy) void (^callBackDateTimeBlock)(NSString *dateString);

//
+ (MTDateAndTimePickerView *)instanceDatePickerView;

- (instancetype)layoutMTDateAndTimePickerViewWithSystemDateStyle;


- (void)show;
- (void)dissmiss;




@end
