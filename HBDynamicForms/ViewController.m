//
//  ViewController.m
//  HBDynamicForms
//
//  Created by mastercom on 2018/3/28.
//  Copyright © 2018年 MT. All rights reserved.
//

#import "ViewController.h"

#import "HBDFScanInputCell.h"  // 输入
#import "HBDFDatePickerCell.h"  // 日期选择
#import "HBDatePickerView.h"

#import "HBDFMultiOptionCell.h"  // 选择
#import "HBDFExcessRemarkCell.h"  // 备注

#import "HBDFLocationCell.h"          // 定位

#import "HBDFUploadIconCell.h"     // 上传图片


#import "HLJZHZWAppointHandleModel.h"
#import "MTEditPopView.h"
#import "MTShowImageBrower.h"

//#import "HLJAreaModel.h"
#import "TZImagePickerController.h"
//#import "TZImageManager.h"

#define noNullStr(object) object == nil||[object isKindOfClass:[NSNull class]]?@"":object

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,HBDFUploadIconCellDelegate,TZImagePickerControllerDelegate>
{
    NSArray * _columns;
    UITableView *_myTableView;
    NSMutableArray *_dataSource;
    
    NSDictionary *_smartUserInfo; // 用户装维信息
    NSDictionary *_configDic; // 本地 创建表单 plist
    
    NSMutableArray *_allAreaModels; // 所有地市区县model
    NSDictionary *_areaDic;  // 地市区县
}
@property (nonatomic, strong) TZImagePickerController *imagePickerController;
@property (nonatomic, strong) MTImagePickerModel *addModel;
@property (nonatomic, strong) NSMutableArray<MTImagePickerModel *> *datas;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setTitle:@"动态表单"];

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"校验" style:UIBarButtonItemStylePlain target:self action:@selector(submitTableAction:)]];
    
    [self initDatas];
    
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init datas
- (void)initDatas
{
    _formatter = [[NSDateFormatter alloc]init];
    _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    _formatter.timeZone = [NSTimeZone systemTimeZone];
    
    // 解析本地配置
    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"repairOrder.plist" ofType:nil];
    _configDic = [NSDictionary dictionaryWithContentsOfFile:localPath];
    _columns =  [_configDic valueForKey:@"Columns"];
    
    // 地市 区县 (改为请求)
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"hljarea" ofType:@"plist"];
    _areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    _dataSource = [[NSMutableArray alloc]init];

    NSDictionary *defaultDic = @{@"联系方式" : @"15012753992"};
    
    for (NSArray *sections in _columns)
    {
        NSMutableArray *sectionArrs = [[NSMutableArray alloc]init];
        for (NSString *title in sections)
        {
            HLJZHZWAppointHandleModel *model = [[HLJZHZWAppointHandleModel alloc] init];
            model.title = title;
            model.value = [[defaultDic allKeys] containsObject:title]? [defaultDic valueForKey:title]: @"";
            model.isNotOptional = YES;
            [sectionArrs addObject:model];
        }
        [_dataSource addObject:sectionArrs];
    }
}

#pragma mark - Lay out
- (void)layoutUI
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"HBDFScanInputCell" bundle:nil] forCellReuseIdentifier:@"HBDFScanInputCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"HBDFDatePickerCell" bundle:nil] forCellReuseIdentifier:@"HBDFDatePickerCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"HBDFMultiOptionCell" bundle:nil] forCellReuseIdentifier:@"HBDFMultiOptionCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"HBDFExcessRemarkCell" bundle:nil] forCellReuseIdentifier:@"HBDFExcessRemarkCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"HBDFLocationCell" bundle:nil] forCellReuseIdentifier:@"HBDFLocationCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"HBDFUploadIconCell" bundle:nil] forCellReuseIdentifier:@"HBDFUploadIconCell"];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _myTableView.estimatedRowHeight = 60.0f;
    _myTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Lazy loading
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

- (TZImagePickerController *)imagePickerController
{
    if(_imagePickerController == nil)
    {
        _imagePickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:64 delegate:self];
        _imagePickerController.allowPickingVideo = NO; // 不允许视频
        _imagePickerController.photoPreviewMaxWidth = 300.0f;
    }
    return _imagePickerController;
}

#pragma mark - Private
- (void)adjustDataSourceWithAppointHandleModel:(HLJZHZWAppointHandleModel *)model
{
    NSMutableArray *tmpDatas = [[NSMutableArray alloc] init];
    
    for (NSArray *sections in _dataSource)
    {
        NSMutableArray *modelArrs = [[NSMutableArray alloc] init];
        
        for (HLJZHZWAppointHandleModel *handleModel in sections)
        {
            if([handleModel.title isEqualToString: model.title])
            {
                handleModel.value = model.value;
                handleModel.isNotOptional = model.isNotOptional;
                handleModel.fileNum = model.fileNum;
            }
            [modelArrs addObject:handleModel];
        }
        [tmpDatas addObject:modelArrs];
    }
    
    _dataSource = [NSMutableArray arrayWithArray:tmpDatas];
    
    // 打印
    for (NSArray *sections in _dataSource)
    {
        for (HLJZHZWAppointHandleModel *model in sections)
        {
            NSLog(@"%@--%@--%@ -- fileNum:%lu",model.title,model.value,model.isNotOptional? @"YES":@"NO",(unsigned long)model.fileNum);
        }
    }
}


/**
 保留数据源原有的值,剔除多余的数据
 */
- (void)resetDataSource
{
    NSArray *oldDataSource = [_dataSource copy];
    [_dataSource removeAllObjects];
    
    for (NSArray *sections in _columns)
    {
        NSArray *oldSource = oldDataSource[[_columns indexOfObject:sections]];
        NSMutableArray *sectionArrs = [[NSMutableArray alloc]init];
        for (NSString *title in sections)
        {
            NSString *oldValue = @"";
            if([sections indexOfObject:title] < [oldSource count])
            {
               HLJZHZWAppointHandleModel *oldModel = oldSource[[sections indexOfObject:title]];
               if([oldModel.title isEqualToString:title]) oldValue = oldModel.value;
            }
            
            HLJZHZWAppointHandleModel *model = [[HLJZHZWAppointHandleModel alloc] init];
            model.title = title;
            model.value = oldValue;
            model.isNotOptional = YES;
            [sectionArrs addObject:model];
        }
        [_dataSource addObject:sectionArrs];
    }
    
    [_myTableView reloadData];
}


- (UIImage *)addMark:(UIImage *)img
{
    NSString *mark = nil;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    dateformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateformatter.timeZone = [NSTimeZone systemTimeZone];
    
    mark = [NSString stringWithFormat:@"上传人: %@\n时间: %@",@"admin",[_formatter stringFromDate:[NSDate date]]];
    //调整起始位置
    CGFloat markOriginY = 120.0f;
    
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    //[[UIColor redColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    [mark drawInRect:CGRectMake(10, h - markOriginY, w, markOriginY) withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:25.0f],NSForegroundColorAttributeName :[UIColor redColor]}];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
}

#pragma mark - Call backs
- (void)submitTableAction:(id)sender
{
    NSLog(@"submitTableAction---");
    // 校验
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    for (NSArray *sections in _dataSource) {
        for (HLJZHZWAppointHandleModel *model in sections){
            
            if(model.isNotOptional && [model.title isEqualToString:@"坐标"])
            {
                NSArray *locations = [model.value componentsSeparatedByString:@","];
                if([locations count] != 2 || [locations[0] doubleValue] == 0 || [locations[1] doubleValue] == 0)
                {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空!",model.title]];
                    return;
                }
            }
            else if(model.isNotOptional && [model.value length] == 0)
            {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空!",model.title]];
                return;
            }
            
            [param addEntriesFromDictionary:@{model.title : model.value}];
        }
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认提交?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitHandle:param];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ensure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)submitHandle:(NSDictionary *)param
{
    NSString *msg = [param mj_JSONString];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ensure];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - GDLIPIUploadIconCellDelegate
- (void)didClickAddBtn
{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)didClickNormalImageWithIndex:(NSInteger)index {
    
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (MTImagePickerModel *model in self.datas)
    {
        [images addObject:model.img];
    }
    MTShowImageBrower *brower = [[MTShowImageBrower alloc]init];
    [brower showWithImages:images index:index];
}

- (void)didClickDeleteWithIndex:(NSInteger)imgIndex;
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认是否要删除?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.datas removeObjectAtIndex:imgIndex];
        [_myTableView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ensure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

//#pragma mark - UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    [self.datas removeAllObjects];
    
    //    UIImage *image = [photos lastObject];
    
    //    if(isSelectOriginalPhoto) [[TZImageManager manager] getOriginalPhotoWithAsset:[assets lastObject] completion:^(UIImage *photo, NSDictionary *info) {
    //        image = photo;
    //    }];
    
    // 先加水印
    //image = [self addMark:image];
    
    // 压缩
    //    CGFloat scale = 0.3f;
    //    CGSize newSize = CGSizeMake(image.size.width*scale, image.size.height*scale);
    //    UIGraphicsBeginImageContext(newSize);
    //    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    //    image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    for (UIImage *image in photos)
    {
        MTImagePickerModel *model = [MTImagePickerModel new];
        model.img = image;
        model.canDelete = YES;
        model.type = MTImagePickerModelTypeImage;
        // Android以imei+时间戳命名
        model.imgName = [NSString stringWithFormat:@"%ld.png",(long)[[NSDate date] timeIntervalSince1970]];;
        [self.datas addObject:model];
    }
    
    [_myTableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source /delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    NSString *title = _columns[indexPath.section][indexPath.row];
    NSDictionary *cellDic = [_configDic valueForKey:title];
    NSString *type = [cellDic valueForKey:@"type"];
    NSString *placeholder = [cellDic objectForKey:@"placeholder"];
    HLJZHZWAppointHandleModel *model = _dataSource[indexPath.section][indexPath.row];
    
    if ([type isEqualToString:@"option"]) // 可选项
    {
        HBDFMultiOptionCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"HBDFMultiOptionCell"];
        cell4.flagImageVIew.hidden = !model.isNotOptional;
        cell4.titleNameLabel.text = title;
        cell4.valueLabel.text = ([model.value length] > 0)?model.value:placeholder;
        cell4.valueLabel.textColor = [cell4.valueLabel.text isEqualToString:placeholder]?[UIColor lightGrayColor]:[UIColor blackColor];
        
        // options 默认id 类型, 正常为NSArray, 若有依赖关系可为NSDictnary
        __block id options = [cellDic objectForKey:@"options"];
        
        if([title isEqualToString:@"地市"]) options = [_areaDic allKeys];
        
        // 取出已选中地市
        if([title isEqualToString:@"区县"])
        {
            for (HLJZHZWAppointHandleModel *selModel in _dataSource[0])
            {
                if([selModel.title isEqualToString:@"地市"])
                {
                    options = [selModel.value length] >0? [_areaDic valueForKey:selModel.value]: @[];
                    break;
                }
            }
        }
        
        __weak typeof(cell4)weakCell4 = cell4;
        cell4.callBackSpinnerBlock = ^(NSString *titleName, NSString *spinnerValue) {
            [weakSelf.view endEditing:YES];
            
            // 依赖关系转换为arrs
            if([options isKindOfClass:[NSDictionary class]])
            {
                // 取的依赖项的值 // 此处默认为前一项
                HLJZHZWAppointHandleModel *model2 = _dataSource[indexPath.section][indexPath.row - 1];
                if ([model2.value length] == 0 || [model2.value isEqualToString:@""])
                {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请先选择%@",model2.title]];
                    return;
                }
                options = [options valueForKey:model2.value];
            }
            
            MTEditPopView *popView = [[MTEditPopView alloc]initWithType:MTEditPopViewSingle delegate:self];
            popView.titles = options;
            popView.selectedArray = spinnerValue?@[spinnerValue]:@[];
            [popView show];
            popView.callBackSeletedStringBlock = ^(NSString *selString) {
                
                if([titleName isEqualToString:@"地市"] && ![selString isEqualToString:weakCell4.valueLabel.text]) // 改变时重置区县
                {
                    NSLog(@"地市被修改了...");
                    HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
                    handleModel.title = @"区县";
                    handleModel.isNotOptional = model.isNotOptional;
                    handleModel.value = @"";
                    [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
                }
                weakCell4.valueLabel.text = selString;
                weakCell4.valueLabel.textColor = [weakCell4.valueLabel.text isEqualToString:@"请选择"]?[UIColor lightGrayColor]:[UIColor blackColor];
                
                HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
                handleModel.title = model.title;
                handleModel.isNotOptional = model.isNotOptional;
                handleModel.value = selString;
                [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
                
                if([titleName isEqualToString:@"地市"]) // 需要刷新
                {
                    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[_columns[0] indexOfObject:@"地市"] inSection:0], [NSIndexPath indexPathForRow:[_columns[0] indexOfObject:@"区县"] inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else if ([title isEqualToString:@"主要原因"])
                {
                    _columns = [_configDic valueForKey:@"Columns"];
                    
                    // 清空次要原因
                    HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
                    handleModel.title = @"次要原因";
                    handleModel.isNotOptional = model.isNotOptional;
                    handleModel.value = @"";
                    [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
                    
                    [weakSelf resetDataSource];
                }
                else if([title isEqualToString:@"次要原因"]) // 动态行数
                {
                    _columns = [selString isEqualToString:@"其他原因"]?[[_configDic valueForKey:@"其他原因"] valueForKey:@"Columns"]: [_configDic valueForKey:@"Columns"];
                    
                    [weakSelf resetDataSource];
                }
            };
        };
        return cell4;
    }
    else if ([type isEqualToString:@"date"]) // 时间可选项
    {
        HBDFDatePickerCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"HBDFDatePickerCell"];
        dateCell.flagImageVIew.hidden = !model.isNotOptional;
        dateCell.titleNameLabel.text = title;
        dateCell.valueLabel.text = ([model.value length] > 0)?model.value:placeholder;
        dateCell.valueLabel.textColor = [dateCell.valueLabel.text isEqualToString:placeholder]?[UIColor lightGrayColor]:[UIColor blackColor];
        
        __weak typeof(dateCell)weakDateCell = dateCell;
        dateCell.callBackDateTimeBlock = ^(NSString *titleName) {
            
            [weakSelf.view endEditing:YES];
            
            HBDatePickerView *pickerView = [HBDatePickerView instanceDatePickerView];
            [pickerView layoutHBDatePickerViewWithDateType:YearMonthDayType];
            [pickerView show];
            pickerView.callBackDatesBlock = ^(HBDateType type, id date) {
                
                // 更新显示
                weakDateCell.valueLabel.text = date;
                weakDateCell.valueLabel.textColor = [weakDateCell.valueLabel.text isEqualToString:@"请选择"]?[UIColor lightGrayColor]:[UIColor blackColor];

                // 更新数据源
                HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
                handleModel.title = model.title;
                handleModel.isNotOptional = model.isNotOptional;
                handleModel.value = date;
                [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
            };
        };
        return dateCell;
    }
    else if ([type isEqualToString:@"textview"]) // 备注描述
    {
        HBDFExcessRemarkCell *cell5 = [tableView dequeueReusableCellWithIdentifier:@"HBDFExcessRemarkCell"];
        cell5.flagImageVIew.hidden = !model.isNotOptional;
        cell5.valueTextView.placeholder = placeholder;
        cell5.titleNameLabel.text = [NSString stringWithFormat:@"%@:",model.title];
        cell5.valueTextView.text = (![model.value isEqualToString:@""]&&[model.value length] != 0)? model.value: placeholder;
        cell5.callBackTextViewContentChangeBlock = ^(NSString *content) {
            
            NSLog(@"detailVc -content:%@",content);
            
            HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
            handleModel.title = model.title;
            handleModel.isNotOptional = model.isNotOptional;
            handleModel.value = content;
            [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
        };
        return cell5;
    }
    else if ([type isEqualToString:@"location"]) // 定位
    {
        HBDFLocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"HBDFLocationCell"];
        locationCell.flagImageVIew.hidden = !model.isNotOptional;
        locationCell.lngTitleLabel.text = @"经度";
        locationCell.latTitleLabel.text = @"纬度";
        locationCell.lngTextField.placeholder = placeholder;
        locationCell.latTextField.placeholder = placeholder;
        
        NSString *coordValue = [model.title isEqualToString:@"坐标"]? model.value :@"";
        locationCell.lngTextField.text = [coordValue length] > 0?[coordValue componentsSeparatedByString:@","][0] : @"";
        locationCell.latTextField.text = [coordValue length] > 0?[coordValue componentsSeparatedByString:@","][1] : @"";
        
        __weak typeof(locationCell)weakCell = locationCell;
        locationCell.callBackGpsBlock = ^(double lng, double lat,BMKReverseGeoCodeResult *result){
            
            NSLog(@"callBackGpsBlock -- lng%f,lat:%f",lng,lat);
            weakCell.lngTextField.text = lng == 0? @"": [NSString stringWithFormat:@"%f",lng];
            weakCell.latTextField.text = lat == 0? @"" : [NSString stringWithFormat:@"%f",lat];
            
            NSString *valueString = [NSString stringWithFormat:@"%f,%f",lng,lat];
            
            HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
            handleModel.title = @"坐标";
            handleModel.isNotOptional = model.isNotOptional;
            handleModel.value = valueString;
            [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
            
            // 地址
            HLJZHZWAppointHandleModel *handleModel1 = [[HLJZHZWAppointHandleModel alloc]init];
            handleModel1.title = @"详细地址";
            handleModel1.isNotOptional = model.isNotOptional;
            handleModel1.value = result != nil? result.address : @""; // 经纬度输入时,可为空项
            [weakSelf adjustDataSourceWithAppointHandleModel:handleModel1];
            
            [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[_columns[0] indexOfObject:@"详细地址"] inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        
        return locationCell;
    }
    else if ([type isEqualToString:@"uploadIcon"]) // 上传照片
    {
        // self.datas
        HBDFUploadIconCell *uploadCell = [tableView dequeueReusableCellWithIdentifier:@"HBDFUploadIconCell"];
        uploadCell.flagImageVIew.hidden = !model.isNotOptional;
        uploadCell.titleNameLabel.text = title;
        uploadCell.decTitleNameLabel.text = [cellDic objectForKey:@"placeholder"];
        uploadCell.countLabel.text = [NSString stringWithFormat:@"%ld(张)",(unsigned long)[self.datas count]];
        uploadCell.showAddBtn = YES; //([self.datas count] < 4)? YES :NO; // 没有数量限制
        uploadCell.delegate = self;
        [uploadCell refreshUI:self.datas];
        
        HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
        handleModel.title = model.title;
        handleModel.isNotOptional = model.isNotOptional;
        handleModel.value = ([self.datas count] > 0)? @"YES" : @""; // 用于校验
        handleModel.fileNum = [self.datas count];
        [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
        
        return uploadCell;
    }
    
    HBDFScanInputCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"HBDFScanInputCell"];
    cell2.flagImageVIew.hidden = !model.isNotOptional;
    cell2.titleNameLabel.text = model.title;
    cell2.valueTextField.placeholder = [cellDic objectForKey:@"placeholder"];
    cell2.valueTextField.text = model.value;
    cell2.valueTextField.textColor = [UIColor blackColor];
    
    cell2.isCanScan = NO;
    cell2.valueTextField.userInteractionEnabled = YES;
    cell2.callBackTextFieldEndEditBlock = ^(NSString *endString) {
        
        NSLog(@"endString-%@",endString);
        
        HLJZHZWAppointHandleModel *handleModel = [[HLJZHZWAppointHandleModel alloc]init];
        handleModel.title = model.title;
        handleModel.isNotOptional = model.isNotOptional;
        handleModel.value = endString;
        [weakSelf adjustDataSourceWithAppointHandleModel:handleModel];
    };
    
    return cell2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _columns[indexPath.section][indexPath.row];
    NSDictionary *cellDic = [_configDic valueForKey:key];
    NSString *type = [cellDic valueForKey:@"type"];
    if ([type isEqualToString:@"uploadIcon"]) return 110.0f;
    if ([type isEqualToString:@"textview"]) return 60.0f;
    if ([type isEqualToString:@"location"]) return 60.0f;
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section != 0)?20.0f:CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return headerView;
}

@end
