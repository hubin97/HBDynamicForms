//
//  MTEditPopView.h
//  ZSWXWLKH
//
//  Created by kingste on 2016/11/29.
//  Copyright © 2016年 MasterCom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MTEditPopViewType) {
    MTEditPopViewSingle = 0,
    MTEditPopViewMultiple,
    MTEditPopViewText,
    MTEditPopViewDate
};

@class MTEditPopView;
@protocol MTEditPopViewDelegate <NSObject>

- (void)MTEditPopView:(MTEditPopView *)popView resultStr:(NSString *)result;

@end

@interface MTEditPopView : UIView

@property (nonatomic) MTEditPopViewType popViewType;
@property (nonatomic, strong) UIColor * mainColor;
@property (nonatomic, copy ) NSString * textViewStr;
@property (nonatomic, strong)NSArray * titles;

/**
 筛选数组,可标识已选项
 */
@property (nonatomic, strong)NSArray *selectedArray;

- (instancetype)initWithType:(MTEditPopViewType)popViewType delegate:(id)delegate;

- (void)addTitle:(NSString *)title;

- (void)show;

@property (nonatomic, assign)id<MTEditPopViewDelegate>delegate;

@property (nonatomic, copy) void (^callBackSeletedStringBlock)(NSString *selString);


@end
