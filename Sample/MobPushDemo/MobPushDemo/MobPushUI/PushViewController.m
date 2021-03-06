//
//  PushViewController.m
//  MobPushDemo
//
//  Created by LeeJay on 2017/9/14.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "PushViewController.h"
#import "UITextView+MPushPlaceholder.h"
#import "TimeTableViewCell.h"
#import "MBProgressHUD+Extension.h"
#import <MOBFoundation/MOBFoundation.h>
#import <MobPush/UIViewController+MobPush.h>
#import "Const.h"

@interface PushViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSString *_sound;
    UIButton *_selected;
}

@property (nonatomic, copy) NSString *vTitle;
@property (nonatomic, copy) NSString *vDescription;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, assign) BOOL isTimedPush;
@property (nonatomic, strong) UITextView *content;

@property (nonatomic, strong) NSMutableArray *selectStatus;
@property (nonatomic, assign) NSInteger timeValue;
@property (nonatomic, assign) MSendMessageType messageType;
@property (nonatomic, strong) MobPush *mobPush;
@property (nonatomic, assign) NSInteger tag;
//场景还原页面参数
@property (nonatomic,strong) NSDictionary *params;

@end

@implementation PushViewController

#pragma mark ---场景还原---

//点击推送场景还原路径
+ (NSString *)MobPushPath
{
    return @"/path/PushViewController";
}

//点击推送场景还原页面参数
- (instancetype)initWithMobPushScene:(NSDictionary *)params
{
    if (self = [super init])
    {
        self.params = params;
        self.vTitle = self.params[@"title"];
        self.vDescription = self.params[@"desc"];
        self.buttonColor = [MOBFColor colorWithRGB:[self.params[@"color"] integerValue]];
        self.messageType = [self.params[@"msgType"] integerValue];
        self.isTimedPush = [self.params[@"isTimedPush"] boolValue];
        self.tag = [self.params[@"tag"] integerValue];
    }
    return self;
}

#pragma mark ---初始化控制器---
- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
         buttonBackgroudColor:(UIColor *)color
                  messageType:(MSendMessageType)type
                  isTimedPush:(BOOL)isTimedPush
{
    return [self initWithTitle:title
                   description:description
          buttonBackgroudColor:color
                   messageType:type
                   isTimedPush:isTimedPush
                           tag:0];
}

- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
         buttonBackgroudColor:(UIColor *)color
                  messageType:(MSendMessageType)type
                  isTimedPush:(BOOL)isTimedPush
                          tag:(NSInteger)tag
{
    if (self = [super init])
    {
        self.vTitle = title;
        self.vDescription = description;
        self.buttonColor = color;
        self.messageType = type;
        self.isTimedPush = isTimedPush;
        self.tag = tag;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _timeValue = 0;
    
    self.title = self.vTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectStatus = [NSMutableArray arrayWithObjects:@(NO),@(NO),@(NO),@(NO),@(NO), nil];

    UILabel *des = [[UILabel alloc] init];
    CGRect textRect = [self.vDescription boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                      context:nil];
    des.frame = (CGRect){20, 16, textRect.size};
    des.text = self.vDescription;
    des.numberOfLines = 0;
    des.textColor = [MOBFColor colorWithRGB:0xA6A6B2];
    des.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:des];
    
    self.content = [[UITextView alloc] init];
    self.content.placeholder = @"填写推送内容（不超过35个字）";
    self.content.placeholderColor = [MOBFColor colorWithRGB:0xA6A6B2];
    self.content.layer.cornerRadius = 2;
    self.content.layer.masksToBounds = YES;
    self.content.layer.borderColor = [MOBFColor colorWithRGB:0xE6E6EC].CGColor;
    self.content.layer.borderWidth = 0.5f;
    self.content.frame = CGRectMake(20, CGRectGetMaxY(des.frame) + 20, self.view.frame.size.width - 40, 80);
    [self.view addSubview:self.content];
    
    UIButton *click = [[UIButton alloc] init];
    [click setTitle:@"点击测试" forState:UIControlStateNormal];
    click.layer.cornerRadius = 2;
    click.layer.masksToBounds = YES;
    [[click titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [click setBackgroundColor:self.buttonColor];
    [click addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:click];
    
    CGFloat maxY = CGRectGetMaxY(_content.frame) + 20;
    if (self.isTimedPush)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.content.frame) + 20, self.view.frame.size.width - 40, 150) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setScrollEnabled:NO];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        maxY = CGRectGetMaxY(tableView.frame) + 20;
    }
    
    if (self.messageType == MPushMessageTypeCustom) {
        click.frame = CGRectMake(20, maxY, self.view.frame.size.width - 40, 40);
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, maxY, self.view.frame.size.width - 40, 40)];
        label.text = @"自定义铃声：";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [MOBFColor colorWithRGB:0xA6A6B2];
        [self.view addSubview:label];
        
        NSArray *buttonNames = @[@"默认音",@"警告音",@"爆炸音",@"科技音"];
        
        for (int i=0; i<buttonNames.count; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+(i%2)*((self.view.frame.size.width-60)/2+20), CGRectGetMaxY(label.frame)+(40+20)*(i/2), (self.view.frame.size.width-60)/2, 40)];
            
            btn.layer.cornerRadius = 2;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = self.buttonColor.CGColor;
            [btn setTitle:buttonNames[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
            [btn setTitleColor:UIColor.darkTextColor forState:UIControlStateSelected];
            [btn setTitleColor:UIColor.darkTextColor forState:UIControlStateNormal];
            [[btn titleLabel] setFont:[UIFont systemFontOfSize:14]];
            [btn setBackgroundImage: [self _imageWithColor:self.buttonColor Size:CGSizeMake((self.view.frame.size.width-60)/2, 40)] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(_customSound:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 10000+i;
            
            if (i==0)
            {
                btn.selected = YES;
                _selected = btn;
            }
            [self.view addSubview:btn];
        }
        
        click.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 60*2+20, self.view.frame.size.width - 40, 40);
    }
    [self setUpForDismissKeyboard];
}

- (UIImage *)_imageWithColor:(UIColor *)color Size:(CGSize)size
{

    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);

    UIGraphicsBeginImageContext(size);

    CGContextRef ref = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(ref, [color CGColor]);

    CGContextFillRect(ref, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"TimeTableViewCell";
    TimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID indexRow:(indexPath.row + 1)];
    }
    
    if (self.tag == 4)
    {
        cell.selectedImage = [UIImage imageNamed:@"selectRed"];
    }
    else
    {
        cell.selectedImage = [UIImage imageNamed:@"select"];
    }
    
    cell.selectedColor = self.buttonColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isSelected = [self.selectStatus[indexPath.row] boolValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectStatus = [NSMutableArray arrayWithObjects:@(NO),@(NO),@(NO),@(NO),@(NO), nil];
    self.selectStatus[indexPath.row] = @(YES);
    
    self.timeValue = indexPath.row + 1;
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)_customSound:(UIButton *)sender
{
    _selected.selected = NO;
    sender.selected = YES;
    _selected  = sender;
    
    switch (sender.tag) {
        case 10000:
            _sound = @"default";
            return;
        case 10001:
            _sound = @"warn.caf";
            return;
        case 10002:
            _sound = @"bomb.caf";
            return;
        case 10003:
            _sound = @"tech.caf";
            return;
            
        default:
            return;
    }
}

- (void)clicked:(id)sender
{
    BOOL isProductionEnvironment;
#ifdef DEBUG
    isProductionEnvironment = NO;
#else
    isProductionEnvironment = YES;
#endif

    if (self.tag == 1)//应用内消息
    {
        if (self.content.text.length < 1 || self.content.text.length > 35)
        {
            [MBProgressHUD showTitle:@"内容不能为空或超过35个字符"];
            return;
        }
        NSString *content_tmp = [self.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (content_tmp.length == 0)
        {
            [MBProgressHUD showTitle:@"内容不能为空或超过35个字符"];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [MobPush sendMessageWithMessageType:self.messageType
                                    content:self.content.text.length ? self.content.text : self.content.placeholder
                                      space:@(self.timeValue)
                                      sound:_sound
                    isProductionEnvironment:isProductionEnvironment
                                     extras:nil
                                 linkScheme:nil
                                   linkData:nil
                                    coverId:nil
                                     result:^(NSString *workId, NSError *error) {
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             
                                             if (error)
                                             {
                                                 [MBProgressHUD showTitle:@"发送失败"];
                                             }
                                             else
                                             {
                                                 [MBProgressHUD showTitle:@"发送成功"];
                                             }
                                         });
                                         
                                     }];
    }
    else
    {
        if (self.content.text.length < 1 || self.content.text.length > 35)
        {
            [MBProgressHUD showTitle:@"内容不能为空或超过35个字符"];
        }
        else
        {
            NSString *content_tmp = [self.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (content_tmp.length == 0)
            {
                [MBProgressHUD showTitle:@"内容不能为空或超过35个字符"];
                return;
            }
            
            if (self.tag == 4)//本地通知
            {
                
                //  本地通知添加方式 此方式v3.0.1开始弃用
                {
//                MPushMessage *message = [[MPushMessage alloc] init];
//                message.identifier = @"111";
//                message.extraInfomation = @{@"test":@2222};
//                message.messageType = MPushMessageTypeLocal;
//                MPushNotification *noti = [[MPushNotification alloc] init];
//                noti.body = self.content.text;
//                noti.title = @"标题";
//                noti.subTitle = @"子标题";
//                noti.sound = _sound;
//                noti.badge = ([UIApplication sharedApplication].applicationIconBadgeNumber < 0 ? 0 : [UIApplication sharedApplication].applicationIconBadgeNumber) + 1;
//                message.notification = noti;
//
//                if (self.timeValue)
//                {
//                    // 设置几分钟后发起本地推送
//                    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
//                    NSTimeInterval nowtime = [currentDate timeIntervalSince1970] * 1000;
//                    NSTimeInterval taskDate = nowtime + self.timeValue*60*1000;
//                    message.taskDate = taskDate;
//                }
//                else
//                {
//                    message.isInstantMessage = YES;
//                }
//
//                [MobPush addLocalNotification:message];
                }
                
                
                //  v3.0.1及以上建议使用方式
                
                MPushNotificationRequest *request = [MPushNotificationRequest new];
                // 推送通知唯一标识
                request.requestIdentifier = @"111";//”推送通知“标识，相同值的“推送通知”将覆盖旧“推送通知”(iOS10及以上)
                
                MPushNotification *content = [MPushNotification new];
                content.title = @"标题";
                content.subTitle = @"子标题";
                content.badge = ([UIApplication sharedApplication].applicationIconBadgeNumber < 0 ? 0 : [UIApplication sharedApplication].applicationIconBadgeNumber) + 1;
                content.body = self.content.text;
                content.action = @"action";// iOS10以下使用
                
                if (Const.shared.DemoAttachmentURL.length > 0 && [NSURL URLWithString:Const.shared.DemoAttachmentURL])
                {
                    content.userInfo = @{@"attachment":Const.shared.DemoAttachmentURL, @"key01":@"value01"};//扩展信息(attachment为多媒体信息，亦可通过content.attachments添加UNNotificationAttachment对象)
                }
                else
                {
                    content.userInfo = @{@"key01":@"value01"};
                }
                
                content.sound = _sound; //本地资源警告音
                //category、threadIdentifier、targetContentIdentifier、...
                
                // 推送通知内容
                request.content = content;
                
                // 推送通知触发条件
                MPushNotificationTrigger *trigger = [MPushNotificationTrigger new];
                
                if (self.timeValue)
                {
                    // 设置几分钟后发起本地推送
                    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval nowtime = [currentDate timeIntervalSince1970] * 1000;
                    NSTimeInterval tasktimeInterval = nowtime + self.timeValue*60*1000;
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
                    {
                        trigger.timeInterval = self.timeValue*60;
                    }
                    else
                    {
                        trigger.fireDate = [NSDate dateWithTimeIntervalSince1970:tasktimeInterval];
                    }
                }
                
                // 根据需求设置条件 trigger.fireDate(iOS10以下)、trigger.dateComponents、trigger.timeInterval、trigger.region
                request.trigger = trigger;//不设置条件或者传nil 认为即时推送
                
                // 添加本地推送
                [MobPush addLocalNotification:request result:^(id result, NSError *error) {
                    if (!error)
                    {
                        //iOS10以上result为UNNotificationRequest对象、iOS10以下成功result为UILocalNotification对象
                        if (result)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showTitle:@"发送成功"];
                                NSLog(@"本地通知添加成功：%@", result);
                            });
                        }
                        
                    }
                }];
                
            }
            else//Apns推送
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                [MobPush sendMessageWithMessageType:self.messageType
                                            content:self.content.text
                                              space:@(self.timeValue)
                                              sound:_sound
                            isProductionEnvironment:isProductionEnvironment
                                             extras:@{
                                                 @"path": @"https://www.baidu.com/",
                                                 @"ordertype": @3,
                                                 @"type": @"reservation",
                                                 @"id": @"d3e6b3c4-38c7-4e69-9fa7-264a83411718"
                                             }
                                         linkScheme:nil
                                           linkData:nil
                                            coverId:nil
                                             result:^(NSString *workId,NSError *error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     
                                                     if (error)
                                                     {
                                                         [MBProgressHUD showTitle:@"发送失败"];
                                                     }
                                                     else
                                                     {
                                                         [MBProgressHUD showTitle:@"发送成功"];
                                                     }
                                                 });
                                             }];
            }
        }
    }
}

//获取当前时间戳
- (NSString *)currentTimeStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", time];
    return timeString;
}

#pragma mark - 任何空白区域键盘事件

- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

@end
