//
//  TagsAndAliasViewController.m
//  MobPushDemo
//
//  Created by LeeJay on 2019/6/17.
//  Copyright © 2019 com.mob. All rights reserved.
//

#import "TagsAndAliasViewController.h"
#import <MobPush/MobPush.h>

@interface TagsAndAliasViewController ()

@property (weak, nonatomic) IBOutlet UITextField *aliasTF;
@property (weak, nonatomic) IBOutlet UITextField *tagsTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TagsAndAliasViewController

- (NSArray<NSString *> *)tags
{
    if ([self.tagsTF.text isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *tagsList = [self.tagsTF.text componentsSeparatedByString:@","];
    return tagsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.title = @"设置别名和标签";
    
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)inputContent:(NSString *)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程操作 UI
        self.textView.text = [self.textView.text stringByAppendingFormat:@"\n %@", content];
    });
}

- (IBAction)setAlias:(id)sender
{
    if ([_aliasTF.text isEqualToString:@""])
    {
        [self inputContent:@"setAlias失败,输入框不能为空！"];
        return;
    }
    
    [MobPush setAlias:_aliasTF.text result:^(NSError *error) {
        if (!error)
        {
            [self getAlias:nil];
        }
        else
        {
            [self inputContent:[NSString stringWithFormat:@"setAlias失败,error:%@", error]];
        }
    }];
}

- (IBAction)deleteAlias:(id)sender
{
    [MobPush deleteAlias:^(NSError *error) {
        if (!error)
        {
            [self inputContent:@"deleteAlias成功！"];
        }
        else
        {
            [self inputContent:[NSString stringWithFormat:@"setAlias失败,error:%@", error]];
        }
    }];
}

- (IBAction)getAlias:(id)sender
{
    [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
        if (!error)
        {
            [self inputContent:[NSString stringWithFormat:@"setAlias成功,alias:%@", alias]];
        }
        else
        {
            [self inputContent:[NSString stringWithFormat:@"setAlias失败,error:%@", error]];
        }
    }];
}

- (IBAction)addTags:(id)sender
{
    if ([self tags].count)
    {
        [MobPush addTags:[self tags] result:^(NSError *error) {
           
            if (!error)
            {
                [self getTagsWithContent:@"addTags"];
            }
            else
            {
                [self inputContent:[NSString stringWithFormat:@"addTags失败,error:%@", error]];
            }
            
        }];
    }
    else
    {
        [self inputContent:[NSString stringWithFormat:@"addTags失败，输入框不能为空"]];
    }
}

- (IBAction)deleteTags:(id)sender
{
    if ([self tags].count)
    {
        [MobPush deleteTags:[self tags] result:^(NSError *error) {
            
            if (!error)
            {
                [self getTagsWithContent:@"deleteTags"];
            }
            else
            {
                [self inputContent:[NSString stringWithFormat:@"addTags失败,error:%@", error]];
            }
            
        }];
    }
    else
    {
        [self inputContent:[NSString stringWithFormat:@"addTags失败，输入框不能为空"]];
    }
}

- (IBAction)clearTags:(id)sender
{
    [MobPush cleanAllTags:^(NSError *error) {
        if (!error)
        {
            [self inputContent:[NSString stringWithFormat:@"clearTags成功"]];
        }
        else
        {
            [self inputContent:[NSString stringWithFormat:@"clearTags失败，输入框不能为空"]];
        }
    }];
}

- (IBAction)getTags:(id)sender
{
    [self getTagsWithContent:@"getTags"];
}

- (void)getTagsWithContent:(NSString *)content
{
    [MobPush getTagsWithResult:^(NSArray *tags, NSError *error) {
        
        if (!error)
        {
            [self inputContent:[NSString stringWithFormat:@"%@成功,tags:%@", content,tags]];
        }
        else
        {
            [self inputContent:[NSString stringWithFormat:@"%@失败,error:%@", content, error]];
        }
        
    }];
}

- (IBAction)clearInput:(id)sender
{
    self.textView.text = nil;
}

@end
