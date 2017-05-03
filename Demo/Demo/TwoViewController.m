//
//  TwoViewController.m
//  Demo
//
//  Created by 刘威振 on 3/20/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "TwoViewController.h"
#import "ZZPopoverWindow.h"

@interface TwoViewController ()

@property (nonatomic) ZZPopoverWindow *popover;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"Item" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)itemClick:(UIButton *)button {
    self.popover = [[ZZPopoverWindow alloc] init];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 200)];
    contentView.backgroundColor = [UIColor blackColor];
    self.popover.contentView = contentView;
    [self.popover showAtView:button];
}

- (IBAction)button1Click:(UIButton *)button {
    UIImageView *imageView   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    imageView.image          = [UIImage imageNamed:@"test.jpg"];
    self.popover             = [[ZZPopoverWindow alloc] init];
    self.popover.showArrow   = NO;
    self.popover.contentView = imageView;
    [self.popover showAtView:button];
}


@end
