
//
//  HBDFExcessRemarkCell.m
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/5.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import "HBDFExcessRemarkCell.h"

@implementation HBDFExcessRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _flagImageVIew.hidden = YES;
    self.valueTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate
//callBackTextViewContentChangeBlock
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textView:%@",textView.text);
    if(_callBackTextViewContentChangeBlock)
    {
        _callBackTextViewContentChangeBlock(textView.text);
    }
}

@end
