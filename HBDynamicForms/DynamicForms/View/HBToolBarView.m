//
//  HBToolBarView.m
//  WorkOrderManagement
//
//  Created by MasterCom on 2017/6/2.
//  Copyright © 2017年 MasterCom. All rights reserved.
//

#import "HBToolBarView.h"
//#import "HBToolBarButton.h"

#define kpadding 5

@interface HBToolBarItem : UIButton

@end

@implementation HBToolBarItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect = contentRect;
    imageRect.size.height = imageRect.size.height *2/3;

    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = contentRect;
    titleRect.origin.y = titleRect.size.height * 2/3;
    titleRect.size.height = titleRect.size.height - titleRect.origin.y;

    return titleRect;
}

@end

@implementation HBToolBarView

- (instancetype)initWithFrame:(CGRect)frame andDatas:(NSArray *)datas
{
    if(self = [super initWithFrame:frame])
    {
        /**
         +++++
         +   +
         +img+
         +++++
         +tip+
         +++++
         */
        //layout
        
        //line
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        [self addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        
        
        //btns
        NSInteger btnCount = [datas count];
        
        CGFloat btnHeight = frame.size.height - 2 *kpadding;
        CGFloat btnWidth  = btnHeight / 1.2;
        
        NSLog(@"btnWidth:%f",btnWidth);
        
        for (NSInteger index = 0; index < btnCount; index ++)
        {
            HBToolBarItem *titleBtn = [HBToolBarItem buttonWithType:UIButtonTypeCustom];
            
            //计算划分区域的每个块X W
            CGFloat areaX = frame.size.width/btnCount * index;
            CGFloat areaW = frame.size.width/btnCount;
            CGFloat btnX  = (areaW - btnWidth)/2 + areaX;
            
            titleBtn.frame = CGRectMake(btnX, kpadding, btnWidth, btnHeight);
            
            titleBtn.tag = index;
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            [titleBtn setTitle:[datas objectAtIndex:index][0] forState:UIControlStateNormal];
            [titleBtn setImage:[UIImage imageNamed:[datas objectAtIndex:index][1]] forState:UIControlStateNormal];
            titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [titleBtn addTarget:self action:@selector(tapTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleBtn];
        }
    }
    return self;
}

//点击后, callback给调用者
- (void)tapTitleBtn:(HBToolBarItem *)sender
{
    NSLog(@"HBToolBarButton:------%@",sender.titleLabel.text);
    
    _titleBtnBlock(sender.tag ,sender.titleLabel.text);
}


@end
