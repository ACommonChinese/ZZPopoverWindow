//
//  ZZPopoverView.m
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/18/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZPopoverView.h"
#import "ZZPopoverWindow.h"
#import "ZZPositionList.h"

// 角度转弧度 convert degree to radius
#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees) / 180)

#define kMinPopMargin 5.0

@interface ZZPopoverView ()

@property (nonatomic) CGRect atViewFrame;
@property (nonatomic) CGPoint arrowShowPoint;
@property (nonatomic) ZZPositionList *positionList;
@property (nonatomic) CGSize arrowSize;
@property (nonatomic) UIEdgeInsets contentInset;
@end

@implementation ZZPopoverView

- (void)setup {
    [self addSubview:self.contentView];
    
    [self initData];
    [self setShadow];
    [self setSize];
    [self setOrigin];
    [self setAnchorPoint];
}

- (void)initData {
    CGRect atViewFrame = [self.atView convertRect:self.atView.bounds toView:self.containerView];
    self.atViewFrame   = atViewFrame;
    self.positionList  = [[ZZPositionList alloc] initWithPosition:self.containerView.popoverPosition];
    self.arrowSize     = self.containerView.showArrow == NO ? CGSizeZero : self.containerView.arrowSize;
    self.contentInset  = self.containerView.showArrow == NO ? UIEdgeInsetsZero : self.containerView.contentInset;
}

- (void)setShadow {
    if (self.containerView.showShadow) {
        self.layer.shadowColor   = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9].CGColor;
        self.layer.shadowOffset  = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius  = 2.0;
    } else {
        self.layer.shadowColor   = nil;
        self.layer.shadowOffset  = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowRadius  = 0.0;
    }
}

- (void)setSize {
    CGRect contentViewFrame = self.containerView.contentView.bounds;
    CGRect popViewFrame = self.frame = contentViewFrame;
    switch (self.positionList.current.position) { // self.containerView.popoverPosition
        case ZZPopoverPositionDown:
        case ZZPopoverPositionUp: {
            popViewFrame.size.width = popViewFrame.size.width + self.contentInset.left + self.contentInset.right;
            popViewFrame.size.height = popViewFrame.size.height + self.contentInset.top + self.contentInset.bottom + self.arrowSize.height;
        } break;
        case ZZPopoverPositionRight:
        case ZZPopoverPositionLeft: {
            popViewFrame.size.width = popViewFrame.size.width + self.contentInset.left + self.contentInset.right + self.arrowSize.width;
            popViewFrame.size.height = popViewFrame.size.height + self.contentInset.top + self.contentInset.bottom;
        } break;
        default:
            break;
    }
    self.frame = popViewFrame;
    self.contentView.frame = contentViewFrame;
}

- (void)setOrigin {
    if (self.positionList.isValid == NO) {
        return;
    }
    
    ZZPopoverPositionObject *positionObj = self.positionList.current;
    ZZPopoverPosition popoverPosition = positionObj.position;
    UIEdgeInsets contentInset = self.contentInset;
    switch (popoverPosition) {
        case ZZPopoverPositionAny: {
            self.containerView.popoverPosition = ZZPopoverPositionDown;
            [self setOrigin];
        } break;
        case ZZPopoverPositionDown: {
            // reset contentView's frame
            CGFloat paddingLeft       = contentInset.left;
            CGFloat paddingTop        = self.arrowSize.height + contentInset.top;
            CGRect contentViewFrame   = self.contentView.frame;
            contentViewFrame.origin.x = paddingLeft;
            contentViewFrame.origin.y = paddingTop;
            self.contentView.frame    = contentViewFrame;
            
            // reset popView's frame
            self.arrowShowPoint      = CGPointMake(CGRectGetMidX(self.atViewFrame), CGRectGetMaxY(self.atViewFrame));
            CGRect popViewFrame      = self.frame;
            popViewFrame.origin.x    = self.arrowShowPoint.x - popViewFrame.size.width * 0.5;
            popViewFrame.origin.y    = self.arrowShowPoint.y;
            self.frame               = popViewFrame;
            
            if (CGRectContainsRect(self.containerView.bounds, self.frame)) {
                self.containerView.popoverPosition = popoverPosition;
                return;
            }
            
            if (self.arrowShowPoint.x >= CGRectGetMidX(self.containerView.bounds)) { // atView in the right
                popViewFrame.origin.x -= (CGRectGetMaxX(popViewFrame) - self.containerView.bounds.size.width + kMinPopMargin);
            } else { // atView in the left
                popViewFrame.origin.x = kMinPopMargin;
            }
            if (CGRectContainsRect(self.containerView.bounds, popViewFrame)) {
                self.frame = popViewFrame;
                self.containerView.popoverPosition = popoverPosition;
            } else {
                // NSLog(@"down 这个方向满足不了要求：");
                self.positionList.down.fail = YES;
                [self changePosition];
            }
        } break;
        case ZZPopoverPositionUp: {
            // reset contentView's frame
            CGRect contentViewFrame   = self.contentView.frame;
            contentViewFrame.origin.x = contentInset.left;
            contentViewFrame.origin.y = contentInset.top;
            self.contentView.frame    = contentViewFrame;
            
            // reset popView's frame
            self.arrowShowPoint = CGPointMake(CGRectGetMidX(self.atViewFrame), CGRectGetMinY(self.atViewFrame));
            CGRect popViewFrame = self.frame;
            popViewFrame.origin.x = self.arrowShowPoint.x - popViewFrame.size.width * 0.5;
            popViewFrame.origin.y = self.arrowShowPoint.y - popViewFrame.size.height;
            self.frame = popViewFrame;
            if (CGRectContainsRect(self.containerView.bounds, self.frame)) {
                self.containerView.popoverPosition = popoverPosition;
                return;
            }
            
            if (self.arrowShowPoint.x >= CGRectGetMidX(self.containerView.bounds)) { // atView in the right
                popViewFrame.origin.x -= (CGRectGetMaxX(popViewFrame) - self.containerView.bounds.size.width + kMinPopMargin);
            } else { // atView in the left
                popViewFrame.origin.x = kMinPopMargin;
            }
            if (CGRectContainsRect(self.containerView.bounds, popViewFrame)) {
                self.frame = popViewFrame;
                self.containerView.popoverPosition = popoverPosition;
            } else {
                // NSLog(@"up 这个方向满足不了要求：");
                self.positionList.up.fail = YES;
                [self changePosition];
            }
        } break;
        case ZZPopoverPositionRight: {
            // reset contentView's frame
            CGRect contentViewFrame   = self.contentView.frame;
            contentViewFrame.origin.x = self.arrowSize.width + contentInset.left;
            contentViewFrame.origin.y = contentInset.top;
            self.contentView.frame    = contentViewFrame;
            
            // reset popView's frame
            self.arrowShowPoint   = CGPointMake(CGRectGetMaxX(self.atViewFrame), CGRectGetMidY(self.atViewFrame));
            CGRect popViewFrame   = self.frame;
            popViewFrame.origin.x = self.arrowShowPoint.x;
            popViewFrame.origin.y = self.arrowShowPoint.y - popViewFrame.size.height * 0.5;
            self.frame            = popViewFrame;
            
            if (CGRectContainsRect(self.containerView.bounds, self.frame)) {
                self.containerView.popoverPosition = popoverPosition;
                return;
            }
            
            if (self.arrowShowPoint.y <= CGRectGetMidY(self.containerView.bounds)) { // atView position: up
                popViewFrame.origin.y = kMinPopMargin;
            } else { // atView position: down
                popViewFrame.origin.y -= (CGRectGetMaxY(popViewFrame) - self.containerView.bounds.size.height + kMinPopMargin);
            }
            
            if (CGRectContainsRect(self.containerView.bounds, popViewFrame)) {
                self.frame = popViewFrame;
                self.containerView.popoverPosition = popoverPosition;
            } else {
                // NSLog(@"right 这个方向满足不了需求");
                self.positionList.right.fail = YES;
                [self changePosition];
            }
        } break;
        case ZZPopoverPositionLeft: {
            // reset contentView's frame
            CGRect contentViewFrame   = self.contentView.frame;
            contentViewFrame.origin.x = self.contentInset.left;
            contentViewFrame.origin.y = self.contentInset.top;
            self.contentView.frame    = contentViewFrame;
            
            // reset popView's frame
            self.arrowShowPoint = CGPointMake(CGRectGetMinX(self.atViewFrame), CGRectGetMidY(self.atViewFrame));
            CGRect popViewFrame = self.frame;
            popViewFrame.origin.x = self.arrowShowPoint.x - popViewFrame.size.width;
            popViewFrame.origin.y = self.arrowShowPoint.y - popViewFrame.size.height * 0.5;
            self.frame = popViewFrame;
            
            if (CGRectContainsRect(self.containerView.bounds, self.frame)) {
                self.containerView.popoverPosition = popoverPosition;
                return;
            }
            
            if (self.arrowShowPoint.y <= CGRectGetMidY(self.containerView.bounds)) { // atView position: up
                popViewFrame.origin.y = kMinPopMargin;
            } else { // atView position: down
                popViewFrame.origin.y -= (CGRectGetMaxY(popViewFrame) - self.containerView.bounds.size.height + kMinPopMargin);
            }
            
            if (CGRectContainsRect(self.containerView.bounds, popViewFrame)) {
                self.frame = popViewFrame;
                self.containerView.popoverPosition = popoverPosition;
            } else {
                // NSLog(@"left 这个方向满足不了需求");
                self.positionList.left.fail = YES;
                [self changePosition];
            }
        } break;
        default:
            break;
    }
}

/**
 *  改变方向
 */
- (void)changePosition {
    [self.positionList nextPositionObject];
    [self setSize];
    [self setOrigin];
}

/**
 *  设置锚点
 */
- (void)setAnchorPoint {
    CGPoint anchorPoint = CGPointZero;
    CGPoint arrorPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    CGRect popViewFrame = self.frame;
    switch (self.containerView.popoverPosition) {
        case ZZPopoverPositionDown: {
            anchorPoint = CGPointMake(arrorPoint.x / CGRectGetWidth(popViewFrame), 0);
        } break;
        case ZZPopoverPositionUp: {
            anchorPoint = CGPointMake(arrorPoint.x / CGRectGetWidth(popViewFrame), 1);
        } break;
        case ZZPopoverPositionRight: {
            anchorPoint = CGPointMake(0, arrorPoint.y / CGRectGetHeight(popViewFrame));
        } break;
        case ZZPopoverPositionLeft: {
            anchorPoint = CGPointMake(1, arrorPoint.y / CGRectGetHeight(popViewFrame));
        } break;
        default:
            break;
    }
    
    CGPoint lastAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    // 锚点和position的移动公式，由于锚点改变，为了使view的位置不发生变化，相应的改变它的position
    self.layer.position = CGPointMake(self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width, self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.containerView.showArrow == NO) {
        return;
    }
    UIBezierPath *arrow   = [[UIBezierPath alloc] init];
    UIColor *contentColor = self.containerView.backgroundColor;
    // the point in the ourself view coordinate
    CGPoint arrowPoint    = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    CGSize arrowSize      = self.arrowSize;
    CGFloat cornerRadius  = 8.0;
    CGSize size           = self.bounds.size;
    
    switch (self.containerView.popoverPosition) {
        case ZZPopoverPositionDown: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width*0.5, arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, arrowSize.height + cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width, size.height - cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, size.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, size.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, size.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(90.0) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, arrowSize.height + cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, arrowSize.height + cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5, arrowSize.height)];
        } break;
        case ZZPopoverPositionUp: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, size.height)];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5, size.height - arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(cornerRadius, size.height - arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, size.height - arrowSize.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(90.0) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width - cornerRadius, 0)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width, size.height - arrowSize.height - cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, size.height - arrowSize.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width * 0.5, size.height - arrowSize.height)];
        } break;
        case ZZPopoverPositionRight: {
            [arrow moveToPoint:CGPointMake(0, arrowPoint.y)];
            [arrow addLineToPoint:CGPointMake(arrowSize.width, arrowPoint.y - arrowSize.height * 0.5)];
            [arrow addLineToPoint:CGPointMake(arrowSize.width, cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(arrowSize.width + cornerRadius, cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width-cornerRadius, 0)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:0.0 clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width, size.height - cornerRadius)];
            
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, size.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowSize.width + cornerRadius, size.height)];
            
            [arrow addArcWithCenter:CGPointMake(arrowSize.width + cornerRadius, size.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(90.0) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowSize.width, arrowPoint.y + arrowSize.height * 0.5)];
        } break;
        case ZZPopoverPositionLeft: {
            [arrow moveToPoint:CGPointMake(size.width, arrowPoint.y)];
            [arrow addLineToPoint:CGPointMake(size.width - arrowSize.width, arrowPoint.y + arrowSize.height * 0.5)];
            [arrow addLineToPoint:CGPointMake(size.width - arrowSize.width, size.height - cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(size.width - arrowSize.width - cornerRadius, size.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(cornerRadius, size.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, size.height - cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(90.0) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width - arrowSize.width - cornerRadius, 0)];
            [arrow addArcWithCenter:CGPointMake(size.width - arrowSize.width - cornerRadius, cornerRadius) radius:cornerRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0.0) clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width - arrowSize.width, arrowPoint.y - arrowSize.height * 0.5)];
        } break;
        default:
            break;
    }
    [contentColor setFill]; // 设置背景填充色
    [arrow fill];
}

@end
