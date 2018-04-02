//
//  HBDFScanInputCell.m
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/5.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import "HBDFScanInputCell.h"

@interface HBDFScanInputCell()
{
    NSRegularExpression *_regEx; // 正则表达式
}
@property (weak, nonatomic) IBOutlet UIButton *qrcodeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrcodeImageWidth;

@end

@implementation HBDFScanInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.flagImageVIew.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _isCanScan = YES;
    _valueTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)qrcodeBtnAction:(id)sender {
    
    if(_callBackQRCodeBlock)
    {
        _callBackQRCodeBlock();
    }
}

- (void)setIsCanScan:(BOOL)isCanScan
{
    _isCanScan = isCanScan;
    
    _qrcodeBtn.hidden = isCanScan? NO:YES;
    _qrcodeImageView.hidden = isCanScan? NO:YES;
    _qrcodeImageWidth.constant = isCanScan? 40.0f:10.0f;
}

- (void)setInputType:(INPUTTYPE)inputType
{
    _inputType = inputType;
    
    if(inputType == INPUTTYPE_INT)
    {
        NSString *regExString = @"^\\d*$";
        _regEx = [NSRegularExpression regularExpressionWithPattern:regExString options:0 error:nil];
        _valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if(inputType == INPUTTYPE_FLOAT)
    {
        NSString *regExString = @"^\\d*\\.{0,1}\\d*$";
        _regEx = [NSRegularExpression regularExpressionWithPattern:regExString options:0 error:nil];
        _valueTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
}

#pragma mark -
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"---textFieldDidEndEditing");
    if(_callBackTextFieldEndEditBlock)
    {
        _callBackTextFieldEndEditBlock(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_regEx == nil) {
        return YES;
    }
    NSString* changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray* matches = [_regEx matchesInString:changedString options:0 range:NSMakeRange(0, changedString.length)];
    return matches.count > 0;
}

@end
