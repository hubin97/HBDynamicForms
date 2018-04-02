//
//  MTDateAndTimePickerView.m
//  WorkOrderManagement
//
//  Created by MasterCom on 2017/6/5.
//  Copyright © 2017年 MasterCom. All rights reserved.
//

#import "MTDateAndTimePickerView.h"

@interface MTDateAndTimePickerView()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;


@property (weak, nonatomic) IBOutlet UIView *contentView;  //选框视图
@property (weak, nonatomic) IBOutlet UIButton *grayBgBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCenterY;


@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;



- (IBAction)sureBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)backGroundBtnAction:(id)sender;

@end

@implementation MTDateAndTimePickerView

#pragma mark - Load
+ (MTDateAndTimePickerView *)instanceDatePickerView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MTDateAndTimePickerView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

#pragma mark - Layout
- (instancetype)layoutMTDateAndTimePickerViewWithSystemDateStyle
{
    self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    
    _grayBgBtn.alpha = 0.2;
    _grayBgBtn.backgroundColor = [UIColor grayColor];
    
    _datePicker.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _datePicker.layer.borderWidth = 1;
    _timePicker.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _timePicker.layer.borderWidth = 1;
    
    
    NSDate *date = [NSDate date];
    
    [_datePicker setDate:date animated:YES];
    [_timePicker setDate:date animated:YES];
    
    return self;
}



#pragma mark - Action
- (void)show
{
    [self setFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentCenterY.constant = 0;
        [self layoutIfNeeded];
    }];
}


- (void)dissmiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentCenterY.constant = - self.frame.size.height;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (IBAction)sureBtnAction:(id)sender {
    
    //回值
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    
    NSString *timeString = [timeFormatter stringFromDate:_timePicker.date];

    NSLog(@"dateString:%@,timeString:%@",dateString,timeString);
    
    if(_callBackDateTimeBlock)
    {
        _callBackDateTimeBlock([NSString stringWithFormat:@"%@ %@",dateString,timeString]);
    }
    
    [self dissmiss];
}

- (IBAction)cancelBtnAction:(id)sender {
    [self dissmiss];
}

- (IBAction)backGroundBtnAction:(id)sender {
    [self dissmiss];
}



@end
