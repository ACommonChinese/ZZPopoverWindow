//
//  ZZPositionList.m
//  LiuWeiZhen
//
//  Created by 刘威振 on 3/19/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZPositionList.h"

@implementation ZZPopoverPositionObject

- (instancetype)initWithPosition:(ZZPopoverPosition)position {
    if (self = [super init]) {
        self.position = position;
    }
    return self;
}
@end

// ------------------------------------------------------

@interface ZZPositionList ()

@end

@implementation ZZPositionList

- (instancetype)initWithPosition:(ZZPopoverPosition)position {
    if (self = [super init]) {
        self.down      = [[ZZPopoverPositionObject alloc] initWithPosition:ZZPopoverPositionDown];
        self.up        = [[ZZPopoverPositionObject alloc] initWithPosition:ZZPopoverPositionUp];
        self.right     = [[ZZPopoverPositionObject alloc] initWithPosition:ZZPopoverPositionRight];
        self.left      = [[ZZPopoverPositionObject alloc] initWithPosition:ZZPopoverPositionLeft];
        self.positions = [NSArray arrayWithObjects:self.down, self.up, self.right, self.left, nil];
        for (ZZPopoverPositionObject *obj in self.positions) {
            if (obj.position == position) {
                self.current = obj;
            }
        }
    }
    return self;
}

- (ZZPopoverPositionObject *)positionObjectWithPosition:(ZZPopoverPosition)position {
    for (ZZPopoverPositionObject *positionObj in self.positions) {
        if (positionObj.position == position) {
            return positionObj;
        }
    }
    return nil;
}

// down -> up -> right -> left
// down <-> up right <-> left
- (ZZPopoverPositionObject *)nextPositionObject {
    if (self.isValid == NO) {
        return nil; // 没有找到可用的方向（下上右左已全部试过）
    }
    
    ZZPopoverPositionObject *positionObj = nil;
    switch (self.current.position) {
        case ZZPopoverPositionDown: {
            positionObj = [self positionObjectWithPosition:ZZPopoverPositionUp];
            if (positionObj.fail == YES) {
                return [self nextPositionObject];
            }
        } break;
        case ZZPopoverPositionUp: {
            positionObj = [self positionObjectWithPosition:ZZPopoverPositionDown];
            if (positionObj.fail == YES) {
                return [self nextPositionObject];
            }
        } break;
        case ZZPopoverPositionRight: {
            positionObj = [self positionObjectWithPosition:ZZPopoverPositionLeft];
            if (positionObj.fail == YES) {
                return [self nextPositionObject];
            }
        } break;
        case ZZPopoverPositionLeft: {
            positionObj = [self positionObjectWithPosition:ZZPopoverPositionRight];
            if (positionObj.fail == YES) {
                return [self nextPositionObject];
            }
        } break;
        default:
            break;
    }
    
    self.current = positionObj;
    return positionObj;
}

- (BOOL)isValid {
    BOOL valid = NO;
    for (ZZPopoverPositionObject *obj in self.positions) {
        if (obj.fail == NO) {
            valid = YES;
            break;
        }
    }
    return valid;
}

@end
