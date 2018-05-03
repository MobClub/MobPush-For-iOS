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

@interface PushViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *vTitle;
@property (nonatomic, copy) NSString *vDescription;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, assign) BOOL isTimedPush;
@property (nonatomic, strong) UITextView *content;

@property (nonatomic, strong) NSMutableArray *selectStatus;
@property (nonatomic, assign) NSInteger timeValue;
@property (nonatomic, assign) MPushMsgType messageType;
@property (nonatomic, strong) MobPush *mobPush;
@property (nonatomic, assign) NSInteger tag;

@end

@implementation PushViewController

- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
         buttonBackgroudColor:(UIColor *)color
                  messageType:(MPushMsgType)type
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
                  messageType:(MPushMsgType)type
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
    
    self.title = self.vTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectStatus = [NSMutableArray arrayWithObjects:@(NO),@(NO),@(NO),@(NO),@(NO), nil];
    
    UILabel *des = [[UILabel alloc] init];
    CGRect textRect = [self.vDescription boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                      context:nil];
    des.frame = (CGRect){20, 80, textRect.size};
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
    
    if (self.isTimedPush)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.content.frame) + 20, self.view.frame.size.width - 40, 150) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setScrollEnabled:NO];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        
        click.frame = CGRectMake(20, CGRectGetMaxY(tableView.frame) + 20, self.view.frame.size.width - 40, 40);
    }
    else
    {
        click.frame = CGRectMake(20, CGRectGetMaxY(self.content.frame) + 20, self.view.frame.size.width - 40, 40);
    }
    
    [self setUpForDismissKeyboard];
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

- (void)clicked:(id)sender
{
    BOOL isProductionEnvironment;
#ifdef DEBUG
    isProductionEnvironment = NO;
#else
    isProductionEnvironment = YES;
#endif
    if (self.tag == 1)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [MobPush sendMessageWithMessageType:self.messageType
                                    content:self.content.text.length ? self.content.text : self.content.placeholder
                                      space:@(self.timeValue)
                    isProductionEnvironment:isProductionEnvironment
                                     extras:nil
                                     result:^(NSError *error) {
                                         
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
            if (self.tag == 4)
            {
                MPushMessage *message = [[MPushMessage alloc] init];
                message.messageType = MPushMessageTypeLocal;
                MPushNotification *noti = [[MPushNotification alloc] init];
                noti.body = self.content.text;
                noti.title = @"标题";
                message.notification = noti;
                
                NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval nowtime = [currentDate timeIntervalSince1970] * 1000;
                
                //设置几分钟后发起本地推送
                NSTimeInterval taskDate = nowtime + self.timeValue*60*1000;
                message.taskDate = taskDate;
                [MobPush addLocalNotification:message];
                
                [MBProgressHUD showTitle:@"发送成功"];
            }
            else
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [MobPush sendMessageWithMessageType:self.messageType
                                            content:self.content.text
                                              space:@(self.timeValue)
                            isProductionEnvironment:isProductionEnvironment
                                             extras:nil
                                             result:^(NSError *error) {
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
