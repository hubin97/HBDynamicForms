//
//  MTImagePickerCell.m
//  GDWWNOP
//
//  Created by QinJ on 2017/8/10.
//  Copyright © 2017年 cn.mastercom. All rights reserved.
//

#import "MTImagePickerCell.h"
#import "MTImagePickerModel.h"
#import "UIImageView+WebCache.h"

@interface MTImagePickerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (nonatomic, strong) MTImagePickerModel *model;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;

@end

@implementation MTImagePickerCell

- (void)refreshUI:(MTImagePickerModel *)model {
    self.model = model;
    
    if (model.url.length) {
        //需要网络请求数据
        NSString *urlStr = [model.url containsString:@"http"]? model.url : [NSString stringWithFormat:@"http://%@/%@" ,kHostUrl, model.url];
        
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //[self.thumbImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"pic_thumb"]];
        [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"pic_thumb"]];
    }
    else {
        self.thumbImageView.image = model.img;
    }
    
    if (model.type == MTImagePickerModelTypeAdd) {
        [self removeGestureRecognizer:self.longGes];
    }
    else {
        [self addGestureRecognizer:self.longGes];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5.f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.clipsToBounds = YES;
}

- (void)deleteImageAction:(UILongPressGestureRecognizer *)longGes {
    if (longGes.state == UIGestureRecognizerStateBegan) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickDeleteBtnWithModel:)]) {
            [self.delegate didClickDeleteBtnWithModel:self.model];
        }
    }
}

#pragma mark -getter
- (UILongPressGestureRecognizer *)longGes {
    if (nil == _longGes) {
        _longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImageAction:)];
    }
    return _longGes;
}

@end
