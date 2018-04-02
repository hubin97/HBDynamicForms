//
//  HBDFDatePickerCell.m
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/5.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import "HBDFDatePickerCell.h"

@implementation HBDFDatePickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.flagImageVIew.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)dateBtnAction:(id)sender {
    
    if(_callBackDateTimeBlock)
    {
        _callBackDateTimeBlock(_titleNameLabel.text);
    }
}
@end
