//
//  ZZPopoverWindow.h
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/17/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPopoverView.h"

@interface ZZPopoverWindow : UIWindow

/**
 *  The contentView positioned in container, default is zero
 *  内边距
 */
@property (nonatomic) UIEdgeInsets contentInset;

/**
 *  The popover arrow size, default is {10.0, 9.0};
 *  箭头尺寸大小，默认{10.0, 9.0}
 */
@property (nonatomic) CGSize arrowSize;

/**
 *  The popover animation show in duration, default is 0.4;
 *  pop显示的动画时间，默认0.4秒
 */
@property (nonatomic) CGFloat animationIn;

/**
 *  The popover animation dismiss duration, default is 0.3;
 *  pop消失的动画时间，默认0.3秒
 */
@property (nonatomic) CGFloat animationOut;

/**
 *  If the drop in animation using spring animation, default is YES;
 *  是否采用spring animation动画(iOS7.0之后出来的一种弹簧动画效果)，默认是YES
 */
@property (nonatomic) BOOL animationSpring;

/**
 *  Show the shadow or not, default YES
 *  是否有阴影，默认YES
 */
@property (nonatomic) BOOL showShadow;

/**
 *  Show the arrow or not, default YES
 *  是否显示箭头，默认YES
 */
@property (nonatomic) BOOL showArrow;

/**
 *  The content view of user
 *  内容视图
 */
@property (nonatomic, weak) UIView *contentView;

/**
 *  The content view's position relative to arrow
 *  内容视图在箭头的哪边(方向)
 */
@property (nonatomic) ZZPopoverPosition popoverPosition;

/**
 *  The callback when popover did show in the containerView
 *  popover在containerView上显示出来后的回调
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  The callback when popover did dismiss in the containerView
 *  popover在containerView上消失后的回调
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

- (void)showAtView:(UIView *)atView;
- (void)showAtView:(UIView *)atView position:(ZZPopoverPosition)position;
- (void)dismiss;

@end
