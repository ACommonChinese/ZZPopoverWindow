//
//  ViewController.m
//  Demo
//
//  Created by 刘威振 on 3/20/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "OneViewController.h"
#import "ZZPopoverWindow.h"
#import "XibView.h"

@interface OneViewController ()

@property (nonatomic) ZZPopoverWindow *popover;
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)button1Click:(UIButton *)button {
    UIView *contentView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
    contentView.backgroundColor = [UIColor redColor];
    UIButton *dismissButton     = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.frame         = CGRectMake(20, 20, 100, 40);
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [contentView addSubview:dismissButton];
    self.popover                = [[ZZPopoverWindow alloc] init];
    // self.popover.popoverPosition = ZZPopoverPositionRight;
    self.popover.contentView    = contentView;
    self.popover.didShowHandler = ^() {
        NSLog(@"Did show");
    };
    self.popover.didDismissHandler = ^() {
        NSLog(@"Did dismiss");
    };
    [self.popover showAtView:button];
}

- (void)dismiss {
    [self.popover dismiss];
}

- (IBAction)button2Click:(UIButton *)button {
    UIImageView *imageView   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.image          = [UIImage imageNamed:@"test.jpg"];
    self.popover             = [[ZZPopoverWindow alloc] init];
    self.popover.popoverPosition = ZZPopoverPositionRight;
    self.popover.contentView = imageView;
    [self.popover showAtView:button];
}

- (IBAction)button3Click:(UIButton *)button {
    UILabel *label               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    label.numberOfLines          = 0;
    label.text                   = @"刘威振\nliuxing8807@126.com";
    label.font                   = [UIFont systemFontOfSize:30.0f];
    label.textAlignment          = NSTextAlignmentCenter;
    self.popover                 = [[ZZPopoverWindow alloc] init];
    self.popover.contentView     = label;
    self.popover.backgroundColor = [UIColor cyanColor];
    [self.popover showAtView:button];
}

- (IBAction)button4Click:(UIButton *)button {
    UIView *contentView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
    contentView.backgroundColor = [UIColor yellowColor];
    self.popover                = [[ZZPopoverWindow alloc] init];
    self.popover.popoverPosition = ZZPopoverPositionRight;
    self.popover.contentView    = contentView;
    [self.popover showAtView:button];
}


- (IBAction)button5Click:(UIButton *)button {
    self.popover = [[ZZPopoverWindow alloc] init];
    XibView *xibView = [XibView xibView];
    self.popover.contentView = xibView;
    self.popover.popoverPosition = ZZPopoverPositionUp;
    self.popover.backgroundColor = [UIColor blackColor];
    [self.popover showAtView:button];
}

@end
