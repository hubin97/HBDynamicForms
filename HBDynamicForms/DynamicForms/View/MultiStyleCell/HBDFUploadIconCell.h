//
//  HBDFUploadIconCell.h
//  ZSWXWLKH
//
//  Created by mastercom on 2018/3/9.
//  Copyright © 2018年 MasterCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTImagePickerModel.h"

@protocol HBDFUploadIconCellDelegate <NSObject>

@optional
- (void)didClickNormalImageWithIndex:(NSInteger)index;
- (void)didClickAddBtn;
- (void)didClickDeleteWithIndex:(NSInteger)imgIndex;

@end


@interface HBDFUploadIconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *decTitleNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageVIew;

// --- --
@property (weak, nonatomic) id<HBDFUploadIconCellDelegate>delegate;
@property (nonatomic, assign, getter=isShowAddBtn) BOOL showAddBtn;

- (void)refreshUI:(NSArray<MTImagePickerModel *> *)selModels;

@end
