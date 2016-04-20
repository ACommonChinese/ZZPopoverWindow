//
//  ZZPopoverWindow.m
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/17/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZPopoverWindow.h"

@interface ZZPopoverWindow ()

@property (nonatomic) UIColor *borderColor;

/**
 *  Pop视图
 */
@property (nonatomic) ZZPopoverView *popView;

/**
 *  箭头所在点
 */
@property (nonatomic) CGPoint showPoint;

@end

@implementation ZZPopoverWindow {
    BOOL _isiOS7;
}

- (instancetype)init {
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _isiOS7              = ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending);
    self.arrowSize       = CGSizeMake(10.0, 9.0);
    self.animationIn     = 0.4;
    self.animationOut    = 0.3;
    self.animationSpring = YES;
    self.showShadow      = YES;
    self.showArrow       = YES;
    self.contentInset    = UIEdgeInsetsMake(5, 5, 5, 5);
    self.popoverPosition = ZZPopoverPositionDown;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.borderColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return self.borderColor;
}

- (void)showAtView:(UIView *)atView {
    [self makeKeyWindow];
    self.windowLevel = UIWindowLevelAlert;
    self.hidden = NO;
    
    /**
    CGFloat contentWidth    = CGRectGetWidth(self.contentView.bounds);
    CGFloat contentHeight   = CGRectGetHeight(self.contentView.bounds);
    CGFloat containerWidth  = CGRectGetWidth(self.bounds);
    NSAssert(contentWidth > 0 && contentHeight > 0,
             @"ZZPopover contentView bounds.size should not be zero");
    NSAssert(containerWidth >= (contentWidth + self.contentInset.left + self.contentInset.right),
             @"ZZPopover containerView width %f should be wider than contentViewWidth %f & "
             @"contentInset %@",
             containerWidth, contentWidth, NSStringFromUIEdgeInsets(self.contentInset));
     */
    
    if (!self.popView) {
        self.popView                 = [[ZZPopoverView alloc] init];
        self.popView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.popView];
        self.popView.containerView   = self;
        self.popView.atView          = atView;
        self.popView.contentView     = self.contentView;
    }

    [self.popView setup];
    [self show];
}

- (void)showAtView:(UIView *)atView position:(ZZPopoverPosition)position {
    self.popoverPosition = position;
    [self showAtView:atView];
}

/**
 *  transform以锚点为基准，修正anchorPoint, 更好的显示弹出效果和消失效果
 */
- (void)righterAnchorPoint {
    
}

- (void)show {
    self.popView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    if (self.animationSpring && _isiOS7) {
        [UIView animateWithDuration:self.animationIn delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.popView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             if (self.didShowHandler) {
                                 self.didShowHandler();
                             }
                         }];
    } else {
        [UIView animateWithDuration:self.animationIn
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.popView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             if (self.didShowHandler) {
                                 self.didShowHandler();
                             }
                         }];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:self.animationOut delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.popView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        // [self.contentView removeFromSuperview];
        [self.popView removeFromSuperview];
        [self resignKeyWindow];
        self.hidden = YES;
        if (self.didDismissHandler) {
            self.didDismissHandler();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}

- (void)dealloc {
    // NSLog(@"dealloc");
}

@end
