//
//  MainItemView.h
//  MobPushDemo
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol IMainItemViewDelegate <NSObject>

- (void)itemClicked:(UIButton *)sender;

@end

@interface MainItemView : UIButton

@property (nonatomic, weak) id<IMainItemViewDelegate> delegate;

+ (instancetype)viewWithTitle:(NSString *)title
                        image:(UIImage *)image
              backgroundImage:(UIImage *)bImage
              backgroundColor:(UIColor *)bColor;

@end
