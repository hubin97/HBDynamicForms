//
//  HLJZHZWAppointHandleModel.h
//  HLJWWNOP
//
//  Created by mastercom on 2017/9/18.
//  Copyright © 2017年 Mastercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLJZHZWAppointHandleModel : NSObject


/**
 标题
 */
@property (nonatomic, copy) NSString *title;


/**
 值
 */
@property (nonatomic, copy) NSString *value;


/**
 是否为必填 必选:YES 
 */
@property (nonatomic, assign) BOOL isNotOptional;


/**
 拍照数量
 */
@property (nonatomic, assign) NSUInteger fileNum;

@end
