//
//  ZZPopoverWindow.m
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/17/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZPopoverWindow.h"

@interface ZZPopoverWindow ()

@property (nonatomic, readwrite) UIColor *borderColor;

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

- (void)commonInit { // NSOrderedAscending
    _isiOS7              = ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedAscending);
    self.arrowSize       = CGSizeMake(10.0, 9.0);
    self.animationIn     = 0.25;
    // self.animationOut = 0.0;
    self.animationSpring = YES;
    self.showShadow      = YES;
    self.showArrow       = YES;
    self.contentInset    = UIEdgeInsetsMake(5, 5, 5, 5);
    self.popoverPosition = ZZPopoverPositionDown;
    self.backgroundColor = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:.5];
    self.borderColor     = [UIColor whiteColor];
    self.minScreenMargin = 5.0;
}

- (void)setShowArrow:(BOOL)showArrow {
    _showArrow = showArrow;
    if (_showArrow == NO) {
        self.contentInset = UIEdgeInsetsZero;
        self.arrowSize = CGSizeZero;
    }
}

- (void)showAtView:(UIView *)atView {
    if (!self.contentView || self.contentView.frame.size.width < 1 || self.contentView.frame.size.height < 1) {
        NSLog(@"Content view is invalid, please check it: %@", self.contentView);
        return;
    }
    
    // ------------------------------------------------------
    // From 1.0.3 change window to view
    // [self makeKeyWindow];
    // self.windowLevel = UIWindowLevelAlert;
    self.hidden = NO;
    if (self.superAttachView) {
        [self.superAttachView addSubview:self];
    } else {
        [UIApplication.sharedApplication.keyWindow addSubview:self];
    }
    // ------------------------------------------------------
    
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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)show {
    self.isShowing = YES;
    if (self.showArrow || self.popoverPosition == ZZPopoverPositionAny) {
        self.popView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        self.popView.endTransform = CGAffineTransformIdentity;
    } else {
        switch (self.popoverPosition) {
            case ZZPopoverPositionDown:
            case ZZPopoverPositionUp: {
                self.popView.startTransform = self.popView.transform = CGAffineTransformMakeScale(1.0, 0.0);
                self.popView.endTransform = CGAffineTransformMakeScale(1.0, 1.0);
                break;
            }
            case ZZPopoverPositionLeft:
            case ZZPopoverPositionRight: {
                self.popView.startTransform = self.popView.transform = CGAffineTransformMakeScale(0.0, 1.0);
                self.popView.endTransform = CGAffineTransformMakeScale(1.0, 1.0);
            }
            default:
                break;
        }
    }
    
    // self.popView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    if (self.animationSpring && _isiOS7) {
        [UIView animateWithDuration:self.animationIn delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.popView.transform = self.popView.endTransform;
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
                             self.popView.transform = self.popView.endTransform;
                         }
                         completion:^(BOOL finished) {
                             if (self.didShowHandler) {
                                 self.didShowHandler();
                             }
                         }];
    }
}

/**
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
*/

- (void)dismiss {
    [UIView animateWithDuration:self.animationOut delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.animationOut <= 0.0001) {
            self.popView.transform = CGAffineTransformIdentity;
        } else {
            // http://stackoverflow.com/questions/2690337/get-just-the-scaling-transformation-out-of-cgaffinetransform
            CGAffineTransform t = self.popView.startTransform;
            double x = sqrt(t.a * t.a + t.c * t.c);
            x = x > 0 ? x : 0.0001;
            double y = sqrt(t.b * t.b + t.d * t.d);
            y = y > 0 ? y : 0.0001;
            CGAffineTransform transform = CGAffineTransformScale(self.popView.transform, x, y);
            self.popView.transform = transform;
        }
    } completion:^(BOOL finished) {
        // [self.contentView removeFromSuperview];
        [self.popView removeFromSuperview];
        //[self resignKeyWindow];
        self.hidden = YES;
        self.isShowing = NO;
        if (self.didDismissHandler) {
            self.didDismissHandler();
        }
        [self removeFromSuperview]; // v1.0.3
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}

//- (void)dealloc {
//    NSLog(@"dealloc, memory ok");
//}

@end
