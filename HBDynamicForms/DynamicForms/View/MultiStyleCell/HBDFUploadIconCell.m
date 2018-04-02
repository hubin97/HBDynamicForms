//
//  HBDFUploadIconCell.m
//  ZSWXWLKH
//
//  Created by mastercom on 2018/3/9.
//  Copyright © 2018年 MasterCom. All rights reserved.
//

#import "HBDFUploadIconCell.h"
#import "MTImagePickerCell.h"

@interface HBDFUploadIconCell ()<UICollectionViewDelegate,UICollectionViewDataSource,MTImagePickerCellDelagate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MTImagePickerModel *addModel;
@property (nonatomic, strong) NSMutableArray<MTImagePickerModel *> *datas;

@end

@implementation HBDFUploadIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.showAddBtn = NO;
    //[self.datas addObject:self.addModel];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置水平滚动
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MTImagePickerCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MTImagePickerCell class])];
}

- (void)refreshUI:(NSArray<MTImagePickerModel *> *)selModels
{
    [self.datas removeAllObjects];
    for (MTImagePickerModel *selModel in selModels) {
        MTImagePickerModel *model = [MTImagePickerModel new];
        model.img = selModel.img;
        model.canDelete = YES;
        model.type = MTImagePickerModelTypeImage;
        [self.datas addObject:model];
    }
    if (self.showAddBtn) {
        [self.datas addObject:self.addModel];
    }
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -collectionView
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = 70;
    return CGSizeMake(width , width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MTImagePickerCell class]) forIndexPath:indexPath];
    [cell refreshUI:self.datas[indexPath.item]];
    cell.delegate = self;
    return cell;
}

- (void)didClickDeleteBtnWithModel:(MTImagePickerModel *)model {
    NSInteger index = [self.datas indexOfObject:model];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickDeleteWithIndex:)]) {
        [self.delegate didClickDeleteWithIndex:index];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datas[indexPath.item].type == MTImagePickerModelTypeAdd) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickAddBtn)]) {
            [self.delegate didClickAddBtn];
        }
    }
    else {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickNormalImageWithIndex:)]) {
            [self.delegate didClickNormalImageWithIndex:indexPath.item];
        }
    }
}

#pragma mark -getter
- (NSMutableArray<MTImagePickerModel *> *)datas {
    if (nil == _datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

-  (MTImagePickerModel *)addModel {
    if (nil == _addModel) {
        _addModel = [MTImagePickerModel new];
        _addModel.img = [UIImage imageNamed:@"imgAdd.png"];
        _addModel.canDelete = NO;
        _addModel.type = MTImagePickerModelTypeAdd;
    }
    return _addModel;
}

@end
