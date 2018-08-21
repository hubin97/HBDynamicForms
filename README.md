# HBDynamicForms
# 动态表单

## (一) 需求效果展示
   <img src="https://github.com/hubin97/HBDynamicForms/blob/master/HBDynamicForms/表单效果图.gif" width=300 />

## (二) Sample code完整编译 
   HBDynamicForms(地址:https://github.com/hubin97/HBDynamicForms)拉取代码后,终端进入项目当前文件夹下执行 $pod install

## (三) Sample code目录分析
   <img src="https://github.com/hubin97/HBDynamicForms/blob/master/HBDynamicForms/samplecode目录分析.png" width=300 />

## (四) Sample code主要框架
   ### IQKeyboardManager:IQKeyboardManager键盘管理工具是iOS开发过程中时常使用的一个第三方库，能够无污染的嵌入到项目开发过程中而不影响代码本身逻辑. GitHub链接: https://github.com/hackiftekhar/IQKeyboardManager
   ### MJExtension: MJExtension是一套字典和模型之间互相转换的超轻量级框架. GitHub链接: https://github.com/CoderMJLee/MJExtension
   ### SVProgressHUD:一款轻量级的 iOS 第三方控件, 用于显示任务加载时的动画, 非常轻便, 容易使用. 相对MBProgressHUD来说,功能上偏少一些,可定制差一些. GitHub链接: https://github.com/SVProgressHUD/SVProgressHUD
   当然了, 此案例中的部分框架也是完全可以由大神ibireme的YYKit去代替的,并且可能功能优化上会有更大提升.这里暂未做尝试. GitHub链接: https://github.com/ibireme/YYKit
   GCPlaceholderTextView可用UITextView占位分类"UITextView+Placeholder.h"替换,应该更优化合理.(https://github.com/devxoul/UITextView-Placeholder)

   ### Podfile文件导入框架如下:
```obj-c
   target 'HBDynamicForms' do
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    # use_frameworks!

    # Pods for HBDynamicForms
    pod 'IQKeyboardManager'
    pod 'SDWebImage'
    pod 'SVProgressHUD'
    pod 'TZImagePickerController'
    pod 'BaiduMapKit'
    pod 'MJExtension'
  end
```
## (五) Sample code结构分析
   ### Model声明
```obj-c
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 值 */
@property (nonatomic, copy) NSString *value;
/** 是否为必填 必选:YES  */
@property (nonatomic, assign) BOOL isNotOptional;
/** 拍照数量 */
@property (nonatomic, assign) NSUInteger fileNum;
```
   当然了,如果页面交互逻辑比较复杂的话,可能会延伸其他的一些附加属性. 如collection布局分section和item模型,然后内部牵涉段的一些操作(eg:折叠/展开,添加/删除等...),item同table一致,也会区分样式布局(根据需要自定义,或仅显示,或可输入,或可选择,或相互关联等...)
   
   ### Cell样式
   <img src="https://github.com/hubin97/HBDynamicForms/blob/master/HBDynamicForms/cell自定义样式.png" width=300 />
     
   ### Controller交互
   案例中交互事件触发多用block处理,cellForRowAtIndexPath代理处较为冗余臃肿,待后续优化.
   
   项目中数据较为简单(暂定为20项以内)以plist配置(repairOrder.plist)稍显直观,其实plist相当于数据模型组建的数据源. (注意:主要原因5->其他原因的动态变化,需要重新拉取段模型)
   
   尽量减少大量数据的处理,如果无法避免,则此时则不再适用plist方式配置. 所以尽可能本地化数据,或是找到规律在代码中枚举或者选用其他方式构建数据源将是不错的选择.
   
   另外如果需求合适也可选用XLForm. GitHub链接: https://github.com/xmartlabs/XLForm
   
