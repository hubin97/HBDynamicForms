//
//  MTImagePickerCell.h
//  GDWWNOP
//
//  Created by QinJ on 2017/8/10.
//  Copyright © 2017年 cn.mastercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTImagePickerModel;

@protocol MTImagePickerCellDelagate <NSObject>

@optional
- (void)didClickDeleteBtnWithModel:(MTImagePickerModel *)model;

@end

@interface MTImagePickerCell : UICollectionViewCell

@property (weak, nonatomic) id<MTImagePickerCellDelagate>delegate;

- (void)refreshUI:(MTImagePickerModel *)model;

@end
