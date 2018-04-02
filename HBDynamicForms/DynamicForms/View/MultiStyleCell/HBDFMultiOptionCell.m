//
//  HBDFMultiOptionCell.m
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/5.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import "HBDFMultiOptionCell.h"
                
@implementation HBDFMultiOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _flagImageVIew.hidden = YES;
    //_flagWidth.constant = 0.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseBtnAction:(id)sender {
    
    if(_callBackSpinnerBlock)
    {
        _callBackSpinnerBlock(_titleNameLabel.text,_valueLabel.text);
    }
}
@end
