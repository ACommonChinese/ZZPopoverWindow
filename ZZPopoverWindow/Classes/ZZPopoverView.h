//
//  ZZPopoverView.h
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/18/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//  https://github.com/ACommonChinese/ZZPopoverWindow
//  email: liuxing8807@126.com

#import <UIKit/UIKit.h>
#import "ZZPositionList.h"

@class ZZPopoverWindow;

@interface ZZPopoverView : UIView

@property (nonatomic) UIView *contentView;
@property (nonatomic, weak) ZZPopoverWindow *containerView;
@property (nonatomic) UIView *atView;

@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) CGAffineTransform endTransform;

- (void)setup;
@end
