//
//  MTImagePickerModel.h
//  GDWWNOP
//
//  Created by QinJ on 2017/8/10.
//  Copyright © 2017年 cn.mastercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTImagePickerModelType) {
    MTImagePickerModelTypeImage,
    MTImagePickerModelTypeAdd,
};

@interface MTImagePickerModel : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *img;

@property (nonatomic, strong) NSString *imgName;

/** < PHAsset or ALAsset > */
@property (nonatomic, strong) id asset;

@property (nonatomic, assign, getter=isCanDelete) BOOL canDelete;
@property (nonatomic, assign) MTImagePickerModelType type;

@end
