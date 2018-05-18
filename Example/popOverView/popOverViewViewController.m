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
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 400, 30, 30)];
    [btn2 setTitle:@"cl" forState:UIControlStateNormal];
    btn2.backgroundColor = UIColor.redColor;
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 30, 30)];
    [btn3 setTitle:@"cl" forState:UIControlStateNormal];
    btn3.backgroundColor = UIColor.redColor;
    [btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(click3:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn3];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
    
- (void)click3:(id)sender {
    
}

- (void)click:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSArray *names = @[@"",@"",@"",@""];
    NSArray *images = @[@"Image",@"Image",@"Image",@"Image"];
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
