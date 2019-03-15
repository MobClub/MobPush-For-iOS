//
//  TimeTableViewCell.h
//  MobPush
//
//  Created by LeeJay on 2017/9/15.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *selectedBadge;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIImage *selectedImage;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexRow:(NSInteger)row;

@end
