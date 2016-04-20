//
//  XibView.m
//  Demo
//
//  Created by 刘威振 on 3/23/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "XibView.h"

@implementation XibView

+ (instancetype)xibView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
