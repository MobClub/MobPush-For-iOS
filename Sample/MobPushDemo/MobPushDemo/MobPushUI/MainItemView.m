//
//  MainItemView.m
//  MobPushDemo
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "MainItemView.h"

@interface MainItemView()

@property (nonatomic, strong) UIImageView *itemImage;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation MainItemView

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
              backgroundImage:(UIImage *)bImage
              backgroundColor:(UIColor *)bColor
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = bColor;
        //[self setBackgroundImage:bImage forState:UIControlStateNormal];
        [self addTarget:self
                 action:@selector(selectedItem:)
       forControlEvents:UIControlEventTouchUpInside];
        
        //图片
        self.itemImage = [[UIImageView alloc] init];
        self.itemImage.image = image;
        [self addSubview:self.itemImage];
        
        //文字
        self.tagLabel = [[UILabel alloc] init];
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        self.tagLabel.textColor = [UIColor blackColor];
        self.tagLabel.text = title;
        self.tagLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.tagLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.itemImage.frame = CGRectMake(self.frame.size.width*0.25, self.frame.size.height*0.05, self.frame.size.width*0.5, self.frame.size.height*0.7);
    
    self.tagLabel.frame = CGRectMake(0, CGRectGetMaxY(self.itemImage.frame) + self.frame.size.height*0.05, self.frame.size.width, self.frame.size.height*0.1);
}

- (void)selectedItem:(UIButton *)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IMainItemViewDelegate)]
        && [self.delegate respondsToSelector:@selector(itemClicked:)])
    {
        [self.delegate performSelector:@selector(itemClicked:) withObject:sender];
    }
}

+ (instancetype)viewWithTitle:(NSString *)title
                        image:(UIImage *)image
              backgroundImage:(UIImage *)bImage
              backgroundColor:(UIColor *)bColor
{
    return [[MainItemView alloc] initWithTitle:title
                                         image:image
                               backgroundImage:bImage
                               backgroundColor:bColor];
}

@end
