//
//  MTEditPopView.m
//  ZSWXWLKH
//
//  Created by kingste on 2016/11/29.
//  Copyright © 2016年 MasterCom. All rights reserved.
//

#import "MTEditPopView.h"

//contentView宽度
#define CONTENTWIDTH [UIScreen mainScreen].bounds.size.width-60
#define CONTENTMAXHEIGHT [UIScreen mainScreen].bounds.size.height-60
#define CONTENTMINHEIGHT [UIScreen mainScreen].bounds.size.height/3

#define DEFAULTCOLOR [UIColor colorWithRed:11/255.0 green:140/255.0 blue:211/255.0 alpha:1]

@interface MTEditPopView ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    
    //super
    UIWindow * _window;
    
    /** 控件 */
    UIView      * _contentView;
    UIView      * _topView;
    UILabel     * _titleLabel;
    UIView      * _bottomView;
    UIButton    * _confirmBtn;
    UIButton    * _cancelBtn;
    UITextView  * _textView;
    UITableView * _tableView;
    
    UIDatePicker * picker;
    UIPickerView * picker2;
    NSArray      * _hourArray;
    NSArray      * _minArray;
    
    /** 数据源 */
    NSMutableArray * _dataSources;
    NSMutableArray * _resultArray;
}

@end

@implementation MTEditPopView {
    /** 约束(高度) */
    NSLayoutConstraint  * _contentViewHeight;
    BOOL _haveShow;
}

#pragma mark - LifeCyle
- (instancetype _Nonnull)initWithType:(MTEditPopViewType)popViewType delegate:(id)delegate {
    if (self = [super init]) {
        _haveShow = NO;
        _dataSources = [[NSMutableArray alloc]init];
        _resultArray = [[NSMutableArray alloc]init];
        self.delegate = delegate;
        self.popViewType = popViewType;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //布局内容
    if (self.popViewType == MTEditPopViewText) {
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = [UIColor blackColor];
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_contentView addSubview:_textView];
        
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7.5-[_textView]-7.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-47.5-[_textView]-47.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
        
        if (_textViewStr) {
            _textView.text = _textViewStr;
        }
        // 监听键盘的弹出和消失
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
    }else if (self.popViewType == MTEditPopViewDate) {
        
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"日期";
        [self addBottomGrayLine:label withSideSpace:5];
        [_contentView addSubview:label];
        
        UILabel * label2 = [[UILabel alloc]init];
        label2.textColor = [UIColor blackColor];
        label2.font = [UIFont systemFontOfSize:14];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"时间";
        [self addBottomGrayLine:label2 withSideSpace:5];
        [_contentView addSubview:label2];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label2.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label2]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label2)]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        
        picker = [[UIDatePicker alloc]init];
        [picker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        picker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
        picker.datePickerMode = UIDatePickerModeDate;
        [picker setDate:[NSDate date] animated:NO];
        [_contentView addSubview:picker];
        
        
        picker2 = [[UIPickerView alloc] init];
        picker2.showsSelectionIndicator=NO;
        picker2.dataSource = self;
        picker2.delegate = self;
        _hourArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",
                       @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
                       @"20",@"21",@"22",@"23"];
        _minArray  = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",
                       @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
                       @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",
                       @"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",
                       @"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",
                       @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
        
        //hourLabel
        UILabel * hourLabel = [[UILabel alloc]init];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        hourLabel.text = @"时";
        
        [picker2 addSubview:hourLabel];
        hourLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [picker2 addConstraint:[NSLayoutConstraint constraintWithItem:hourLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:picker2 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [picker2 addConstraint:[NSLayoutConstraint constraintWithItem:hourLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:picker2 attribute:NSLayoutAttributeCenterX multiplier:1 constant:-15]];
        [picker2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[hourLabel(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hourLabel)]];
        [picker2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hourLabel(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hourLabel)]];
        
        //minLabel
        UILabel * minLabel = [[UILabel alloc]init];
        minLabel.textAlignment = NSTextAlignmentCenter;
        minLabel.text = @"分";
        
        [picker2 addSubview:minLabel];
        minLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [picker2 addConstraint:[NSLayoutConstraint constraintWithItem:minLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:picker2 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [picker2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[minLabel(30)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(minLabel)]];
        [picker2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minLabel(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(minLabel)]];
        
        [_contentView addSubview:picker2];
        
        picker.translatesAutoresizingMaskIntoConstraints = NO;
        picker2.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[picker]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(picker)]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[picker2]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(picker2)]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[label(20)]-5-[picker(picker2)]-5-[label2(20)]-5-[picker2]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label,picker,label2,picker2)]];
        
        CGFloat realContentHeight = 587-0.5;
        if (realContentHeight>CONTENTMAXHEIGHT) {
            _contentViewHeight.constant = CONTENTMAXHEIGHT;
        }else{
            _contentViewHeight.constant = realContentHeight;
        }
    }else{
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_contentView addSubview:_tableView];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_tableView]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        
        //根据内容调整高度
        CGFloat realContentHeight = 40+40+_dataSources.count*44-0.5;
//        if (realContentHeight<CONTENTMINHEIGHT) {
//            _contentViewHeight.constant = CONTENTMINHEIGHT;
//        }else
        if (realContentHeight>CONTENTMAXHEIGHT) {
            _contentViewHeight.constant = CONTENTMAXHEIGHT;
        }else{
            _contentViewHeight.constant = realContentHeight;
        }
    }
    
    
    
}

- (void)show {
    if (_haveShow) {
        return;
    }
    //background
    [self setupBackground];
    
    //contentView
    [self setupContentView];
    
    //show
    [self addPopAnimation];
}


#pragma mark - InitUI
- (void)setupBackground {
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [_window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    [_window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer * backgaroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgaroundTapClick:)];
    [self addGestureRecognizer:backgaroundTap];
}

- (void)setupContentView {
    
    //contentView
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [_window addSubview:_contentView];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //居中
    [_window addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_window addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //宽度
    NSString * widthStr = [NSString stringWithFormat:@"H:[_contentView(%f)]",CONTENTWIDTH];
    NSString * heightStr= [NSString stringWithFormat:@"V:[_contentView(%f)]",CONTENTMINHEIGHT];
    
    [_window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    _contentViewHeight = [NSLayoutConstraint constraintsWithVisualFormat:heightStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentView)][0];
    [_window addConstraint:_contentViewHeight];
    
    //topView
    [self setupTopView];
    //buttomView
    [self setupButtomView];
}

- (void)setupTopView {
    _topView = [[UIView alloc]init];//11 140 211
    _topView.backgroundColor = self.mainColor?self.mainColor:DEFAULTCOLOR;
    [_contentView addSubview:_topView];
    
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topView)]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_topView(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topView)]];
    
    //imageView,titleLabel
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dialog_icon_warn"]];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    if (self.popViewType == MTEditPopViewText) {
        _titleLabel.text = @"请填写";
    }else if (self.popViewType == MTEditPopViewDate) {
        _titleLabel.text = @"设置日期";
    }else if (self.popViewType == MTEditPopViewMultiple) {
        _titleLabel.text = @"请选择(多选)";
    }else {
        _titleLabel.text = @"请选择";
    }
    
    [_topView addSubview:imageView];
    [_topView addSubview:_titleLabel];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_topView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [_topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [_topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[imageView(20)]-5-[_titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView,_titleLabel)]];
}

- (void)setupButtomView {
    UIColor * firstColor = self.mainColor?self.mainColor:DEFAULTCOLOR;
    UIColor * secondColor= [UIColor whiteColor];
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = firstColor;
    [_contentView addSubview:_bottomView];
    
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bottomView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomView)]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomView(40)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomView)]];
    
    //_confirmBtn,_cancelBtn;
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:firstColor forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:secondColor forState:UIControlStateHighlighted];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmBtn setBackgroundImage:[self imageWithColor:secondColor] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[self imageWithColor:firstColor] forState:UIControlStateHighlighted];
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_confirmBtn];
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:firstColor forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:secondColor forState:UIControlStateHighlighted];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelBtn setBackgroundImage:[self imageWithColor:secondColor] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[self imageWithColor:firstColor] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_cancelBtn];
    
    _confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.5-[_confirmBtn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmBtn)]];
    [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.5-[_cancelBtn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelBtn)]];
    [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_confirmBtn(_cancelBtn)]-0.5-[_cancelBtn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmBtn,_cancelBtn)]];
}

- (void)addBottomGrayLine:(UIView *)view withSideSpace:(NSInteger)distance {
    UIView * grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:grayLine];
    
    grayLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSString * H_str = [NSString stringWithFormat:@"H:|-%ld-[grayLine]-%ld-|",distance,distance];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:H_str options:0 metrics:nil views:NSDictionaryOfVariableBindings(grayLine)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[grayLine(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(grayLine)]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString * reuseID = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if ( cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.numberOfLines = 0;
//        
//        //grayLine
//        UIView * grayLine = [[UIView alloc]init];
//        grayLine.backgroundColor = [UIColor lightGrayColor];
//        [cell addSubview:grayLine];
//        grayLine.translatesAutoresizingMaskIntoConstraints = NO;
//        [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[grayLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(grayLine)]];
//        [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[grayLine(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(grayLine)]];
//    }
    
    NSString * text = _dataSources[indexPath.row];
    
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    if ([_resultArray containsObject:text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Actions
- (void)confirmBtnClick:(UIButton *)button {
    
    if (_textView) {
        [_textView resignFirstResponder];
    }
    
    NSString * returnStr;
    if (self.popViewType == MTEditPopViewDate) {
        
        NSDate * YMD = picker.date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSInteger row   = [picker2 selectedRowInComponent:0];
        NSInteger row2  = [picker2 selectedRowInComponent:1];
        NSString * hour = [_hourArray objectAtIndex:row];
        NSString * min  = [_minArray objectAtIndex:row2];
        
        
        NSString * YMD_str = [dateFormatter stringFromDate:YMD];
        NSString * HM_str = [NSString stringWithFormat:@"%@:%@:00",hour,min];
        
        returnStr = [NSString stringWithFormat:@"%@ %@",YMD_str,HM_str];
    }else if (self.popViewType == MTEditPopViewText) {
        returnStr = _textView.text;
    }else if (self.popViewType == MTEditPopViewSingle) {
        returnStr = [_resultArray componentsJoinedByString:@","];
        //单选不选时截断
        if (_resultArray.count==0) {
            [SVProgressHUD showErrorWithStatus:@"请选择一项"];
            return;
        }
    }else{
        returnStr = [_resultArray componentsJoinedByString:@","];
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(MTEditPopView:resultStr:)]) {
        [self.delegate MTEditPopView:self resultStr:returnStr];
    }
    
    if(_callBackSeletedStringBlock)
    {
        _callBackSeletedStringBlock(returnStr);
    }
    
    [self cancelBtnClick:nil];
}

- (void)cancelBtnClick:(UIButton *)button {
    [self removeFromSuperview];
    [_contentView removeFromSuperview];
}

- (void)backgaroundTapClick:(UIGestureRecognizer *)backgaroundTap {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
        return;
    }
//    [self cancelBtnClick:nil];
    NSLog(@"%s",__func__);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString * cellTitle = _dataSources[indexPath.row];
    if (self.popViewType == MTEditPopViewMultiple) {
        if ([_resultArray containsObject:cellTitle]) {
            [_resultArray removeObject:cellTitle];
        }else{
            [_resultArray addObject:cellTitle];
        }
    }else{
        [_resultArray removeAllObjects];
        [_resultArray addObject:cellTitle];
    }
    [_tableView reloadData];
}

- (void)addPopAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithDouble:0.f];
    animation.toValue   = [NSNumber numberWithDouble:1.f];
    animation.duration  = .25f;
    animation.fillMode  = kCAFillModeBackwards;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)setTextViewStr:(NSString *)textViewStr {
    _textViewStr = textViewStr;
    
    if (_textView&&self.popViewType == MTEditPopViewText) {
        _textView.text = textViewStr;
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    [_dataSources removeAllObjects];
    [_dataSources addObjectsFromArray:titles];
}

- (void)setSelectedArray:(NSArray *)selectedArray
{
    if([selectedArray count] > 0)
    {
        _resultArray = [NSMutableArray arrayWithArray:selectedArray];
    }
}

- (void)addTitle:(NSString *)title {
    [_dataSources addObject:title];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_hourArray count];
    }
    return [_minArray count];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_hourArray objectAtIndex:row];
    } else {
        return [_minArray objectAtIndex:row];
        
    }
}

#pragma mark - 键盘弹出
- (void) keyboardShow:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    //    int width = keyboardRect.size.width;
    //获取键盘弹出要用的时间
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //如果键盘把文本框遮住
    [UIView animateWithDuration:animationDuration animations:^{
        _window.transform = CGAffineTransformMakeTranslation(0, -height/2.0);
    }];
}

- (void) keyboardHide:(NSNotification*)notification{
    //获取键盘弹出要用的时间
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        _window.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)applicationWillResignActive:(NSNotification *)noti {
    [_textView resignFirstResponder];
}

#pragma mark - Other
-(void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
