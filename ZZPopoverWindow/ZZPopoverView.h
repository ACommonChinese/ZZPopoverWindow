//
//  ZZPopoverView.h
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/18/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPositionList.h"

@class ZZPopoverWindow;

@interface ZZPopoverView : UIView

//@property (nonatomic) ZZPopoverViewInfo *info;
@property (nonatomic) UIView *contentView;
@property (nonatomic, weak) ZZPopoverWindow *containerView;
@property (nonatomic) UIView *atView;

- (void)setup;
@end
