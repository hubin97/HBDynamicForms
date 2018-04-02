//
//  HBDFExcessRemarkCell.h
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/5.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface HBDFExcessRemarkCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *valueTextView;

// 默认隐藏 星标
@property (weak, nonatomic) IBOutlet UIImageView *flagImageVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagWidth;


/**
 回调textView修改后的值
 */
@property (nonatomic, copy) void (^callBackTextViewContentChangeBlock)(NSString *content);

@end
