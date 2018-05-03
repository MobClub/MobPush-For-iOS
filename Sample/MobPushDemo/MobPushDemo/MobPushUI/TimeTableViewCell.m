//
//  TimeTableViewCell.m
//  MobPush
//
//  Created by LeeJay on 2017/9/15.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     indexRow:(NSInteger)row
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupElementWithRow:row];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    [self setNeedsLayout];
}

- (void)setupElementWithRow:(NSInteger)row
{
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.frame = CGRectMake(0, 5, 100, 20);
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.text = [NSString stringWithFormat:@"%zi分钟",row];
    [self.contentView addSubview:self.timeLabel];
    
    self.selectedBadge = [[UIImageView alloc] init];
    [self.contentView addSubview:self.selectedBadge];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cxt, 0.5);
    CGContextSetStrokeColorWithColor(cxt, [UIColor colorWithWhite:0.910 alpha:1.000].CGColor);
    CGContextMoveToPoint(cxt, 0.0 , self.frame.size.height - 0.5);
    CGContextAddLineToPoint(cxt,self.frame.size.width , self.frame.size.height - 0.5);
    CGContextStrokePath(cxt);
}

- (void)layoutSubviews
{
    if (self.isSelected)
    {
        self.timeLabel.textColor = self.selectedColor;
        self.selectedBadge.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10, 10, 10);
        self.selectedBadge.image = self.selectedImage;
        self.selectedBadge.hidden = NO;
    }
    else
    {
        self.timeLabel.textColor = [UIColor grayColor];
        self.selectedBadge.hidden = YES;
    }
}

@end
