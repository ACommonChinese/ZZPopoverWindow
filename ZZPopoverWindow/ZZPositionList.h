//
//  ZZPositionList.h
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/19/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  弹框在控件的哪个位置
 */
typedef NS_ENUM(NSInteger, ZZPopoverPosition) {
    /**
     *  任意方向，优先次序：下上右左 ZZPopoverWindowPositionDown,
     */
    ZZPopoverPositionAny,
    /**
     *  弹框在控件下方，默认值
     */
    ZZPopoverPositionDown,
    /**
     *  弹框在控件上方
     */
    ZZPopoverPositionUp,
    /**
     *  弹框在控件左侧
     */
    ZZPopoverPositionLeft,
    /**
     *  弹框在控件右侧
     */
    ZZPopoverPositionRight,
};

// ------------------------------------------------------

@interface ZZPopoverPositionObject : NSObject

@property (nonatomic) ZZPopoverPosition position;
@property (nonatomic) BOOL fail; // 失败，如果此position不能满足需求（即，超出屏幕），此字段置为YES

- (instancetype)initWithPosition:(ZZPopoverPosition)position;
@end

// ------------------------------------------------------

@interface ZZPositionList : NSObject

@property (nonatomic) NSArray *positions;
@property (nonatomic) ZZPopoverPositionObject *down;
@property (nonatomic) ZZPopoverPositionObject *up;
@property (nonatomic) ZZPopoverPositionObject *left;
@property (nonatomic) ZZPopoverPositionObject *right;
@property (nonatomic) ZZPopoverPositionObject *current;
@property (nonatomic) BOOL isValid;

- (instancetype)initWithPosition:(ZZPopoverPosition)position;
- (ZZPopoverPositionObject *)nextPositionObject;
@end
