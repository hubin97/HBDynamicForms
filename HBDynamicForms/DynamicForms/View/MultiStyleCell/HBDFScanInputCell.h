//
//  HBDFScanInputCell.h
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/5.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    INPUTTYPE_INT = 0,
    INPUTTYPE_FLOAT
} INPUTTYPE;

@interface HBDFScanInputCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, copy) void (^ callBackQRCodeBlock)(void);
@property (nonatomic, copy) void (^ callBackTextFieldEndEditBlock)(NSString *endString);

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

// 默认隐藏 星标
@property (weak, nonatomic) IBOutlet UIImageView *flagImageVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagWidth;

/**
  输入类型, 设置正则表达式约束 和键盘样式
 */
@property (nonatomic, assign) INPUTTYPE inputType;

/**
 是否可以扫描输入, 默认为YES
 */
@property (nonatomic, assign) BOOL isCanScan;

- (IBAction)qrcodeBtnAction:(id)sender;

@end
