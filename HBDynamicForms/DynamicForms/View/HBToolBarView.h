//
//  HBToolBarView.h
//  WorkOrderManagement
//
//  Created by MasterCom on 2017/6/2.
//  Copyright © 2017年 MasterCom. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 底部提交视图 */
@interface HBToolBarView : UIView

/**
 实现被点击的按钮下标和内容回调
 */
@property (nonatomic, copy) void (^ titleBtnBlock) (NSInteger index, NSString *title);


/**
 初始化
 @param datas @[@[title, iconname],@[]]
 */
- (instancetype)initWithFrame:(CGRect)frame andDatas:(NSArray *)datas;


@end
