//
//  popOverViewViewController.m
//  popOverView
//
//  Created by zygmain@gmail.com on 05/17/2018.
//  Copyright (c) 2018 zygmain@gmail.com. All rights reserved.
//

#import "popOverViewViewController.h"
#import "UIView+popOverView.h"

@interface popOverViewViewController ()

@end

@implementation popOverViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(300, 300, 30, 30)];
    [btn setTitle:@"cl" forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.redColor;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)click:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSArray *names = @[@"Reply",@"Share",@"Copy",@"Report"];
    NSArray *images = @[@"popover_reply",@"popover_share",@"popover_copy",@"popover_report"];
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i<names.count; i++) {
        PopoverItem *item = [PopoverItem itemWithName:names[i] image:[UIImage imageNamed:images[i]] selectedHandler:^(PopoverItem *popoverItem) {
            
        }];
        [items addObject:item];
    }

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [window convertRect:btn.frame fromView:self.view];
    [self.view showPopoverWithItems:items forRect:rect];
}

@end
