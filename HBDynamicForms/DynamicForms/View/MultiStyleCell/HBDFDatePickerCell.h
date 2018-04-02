//
//  HBDFDatePickerCell.h
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/5.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBDFDatePickerCell : UITableViewCell

@property (nonatomic, copy) void (^ callBackDateTimeBlock)(NSString *titleName);

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseBtnImageView;

// 默认隐藏 星标
@property (weak, nonatomic) IBOutlet UIImageView *flagImageVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagWidth;

- (IBAction)dateBtnAction:(id)sender;

@end
