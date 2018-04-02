//
//  HBDatePickerView.h
//  FengurUWDatePickerDemo
//
//  Created by MasterCom on 2017/5/17.
//  Copyright © 2017年 UWFengur. All rights reserved.
//

#import <UIKit/UIKit.h>


#define HBViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

typedef NS_ENUM(NSUInteger, HBDateType) {
    // 常用类型
    YearMonthDayType  = 0,    //H 0.5
    // 第几周
    WeekOfYearType    = 1,    //H 0.5
    // 开始日期 结束日期  (只有年月)
    YearMonthAtoZType,        //H 0.76
};


@protocol HBDatePickerViewDelegate <NSObject>

/**
 *  选择日期确定后的代理事件
 *
 *  @param dates 日期数组
 *  @param type 时间选择器状态
 */
- (void)getSelectDates:(NSArray *)dates type:(HBDateType)type;


/**
 回调周下标

 @param index 当年第几周
 */
- (void)getSelectWeeksIndex:(NSUInteger)index;

@end


@interface HBDatePickerView : UIView

@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UIView *bgView;  //选框视图
@property (weak, nonatomic) IBOutlet UIButton *grayBgBtn;

@property (nonatomic, weak)   id<HBDatePickerViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel  *startLabel;
@property (weak, nonatomic) IBOutlet UILabel  *endLabel;

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView1;  //年月日/周/ 起始
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView2;  //截止

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, strong) NSDate *currentDate; //默认显示时间


/**
 预期回调
 YearMonthDayType  - 年月日 datestring
 WeekOfYearType    - 周下标 nsnumber
 YearMonthAtoZType - 数组[startdatestring,enddatestring]
 */
@property (nonatomic, copy) void (^callBackDatesBlock)(HBDateType type, id date);

//
+ (HBDatePickerView *)instanceDatePickerView;

- (void)layoutHBDatePickerViewWithDateType:(HBDateType)type;

/**
 滚动到指定的时间位置

 @param date 日期
 @param animated 是否动画
 */
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated;

/**
 获取当前日期为当年第几周
 
 @param date 日期
 @return 显示字段
 */
- (NSInteger)getWeekIndexInYearWithDate:(NSDate *)date;

- (void)show;
- (void)dissmiss;



- (IBAction)sureBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)backGroundBtnAction:(id)sender;

@end
