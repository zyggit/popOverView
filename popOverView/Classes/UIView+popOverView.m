//
//  UIView+popOverView.m
//  Pods-popOverView_Example
//
//  Created by zhaoyuguang on 2018/5/17.
//

#import "UIView+popOverView.h"
#import <objc/runtime.h>

@implementation PopoverItem

+ (instancetype)itemWithName:(NSString *)name image:(UIImage *)image selectedHandler:(PopoverItemSelectHandler)handler {
    PopoverItem *item = [[PopoverItem alloc]init];
    [item setValue:name forKey:@"name"];
    [item setValue:image forKey:@"image"];
    [item setValue:handler forKey:@"handler"];
    return item;
}

@end

typedef NS_ENUM(NSInteger,TableViewPopoverDirection) {
    TableViewPopoverDirectionUp,
    TableViewPopoverDirectionDown,
};

@interface PopoverButton : UIButton

@end

@implementation PopoverButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super titleRectForContentRect:contentRect];
    return CGRectMake((CGRectGetWidth(contentRect)-CGRectGetWidth(rect))/2, CGRectGetHeight(contentRect)-CGRectGetHeight(rect)-5, CGRectGetWidth(rect), CGRectGetHeight(rect));
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super imageRectForContentRect:contentRect];
    return CGRectMake((CGRectGetWidth(contentRect)-CGRectGetWidth(rect))/2, 7.5, CGRectGetWidth(rect), CGRectGetHeight(rect));
}

@end


@interface TableViewPopover : UIView

@property (nonatomic,assign) TableViewPopoverDirection direction;
@property(nonatomic,strong) UIColor *toolBarColor;
@end


@implementation TableViewPopover

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.toolBarColor = [UIColor colorWithRed:176.0/255.0 green:138.0/255.0 blue:246.0/255.0 alpha:1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offset;
    switch (self.direction) {
        case TableViewPopoverDirectionUp: {
            offset = 0;
        }
            break;
        default: {
            offset = 8;
        }
            break;
    }
    for (UIView *subView in self.subviews) {
        subView.frame = CGRectMake(subView.frame.origin.x, offset, CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
    }
}

- (void)setDirection:(TableViewPopoverDirection)direction {
    if (_direction == direction) {
        return;
    }
    _direction = direction;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
    CGRect roundRect;
    CGPoint p;
    CGPoint o;
    switch (self.direction) {
        case TableViewPopoverDirectionUp: {
            roundRect = CGRectMake(rect.origin.x, rect.origin.y, CGRectGetWidth(rect), CGRectGetHeight(rect)-8);
            p = CGPointMake(CGRectGetWidth(roundRect)-37, roundRect.origin.y+CGRectGetHeight(roundRect));
            o = CGPointMake(CGRectGetWidth(rect)-30, CGRectGetHeight(rect)+rect.origin.y);
        }
            break;
        default: {
            roundRect = CGRectMake(rect.origin.x, rect.origin.y+8, CGRectGetWidth(rect), CGRectGetHeight(rect)-8);
            p = CGPointMake(CGRectGetWidth(roundRect)/2-7, roundRect.origin.y);
            o = CGPointMake(CGRectGetWidth(rect)-30, rect.origin.y);
        }
            break;
    }
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:roundRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7, 7)];
    [roundPath moveToPoint:p];
    [roundPath addLineToPoint:o];
    [roundPath addLineToPoint:CGPointMake(p.x+14, p.y)];
    [roundPath closePath];
    [self.toolBarColor setFill];
    [roundPath fill];
}

@end


static const char *PopoverKey = "PopoverKey";
static const char *PopoverBgKey = "PopoverBgKey";
static const char *PopoverItemsKey = "PopoverItemsKey";
static const char *PopoverTapGestureKey = "PopoverTapGestureKey";
static const char *PopoverBtnKey = "PopoverTapBtnKey";
static const CGFloat itemWidth = 45;
static const CGFloat itemHeight = 70;

@implementation UIView (popOverView)


- (void)showPopoverWithItems:(NSArray<PopoverItem *> *)items forRect:(CGRect )rect {
    if (items.count <= 0) {
        NSLog(@"At least one item!!!");
        return;
    }
    else if (items.count > (NSInteger)CGRectGetWidth(self.frame)/itemWidth) {
        NSLog(@"Can not be more than %f items!!!",CGRectGetWidth(self.frame)/itemWidth);
        return;
    }
    
    NSArray *popoverItems = objc_getAssociatedObject(self, PopoverItemsKey);
    if (popoverItems == nil) {
        popoverItems = [items copy];
        objc_setAssociatedObject(self, PopoverItemsKey, popoverItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    TableViewPopover *popover = objc_getAssociatedObject(self, PopoverKey);
    UIView *popoverBg = objc_getAssociatedObject(self, PopoverBgKey);
    NSMutableArray *popItemArr = [[NSMutableArray alloc] init];
    if (popover == nil) {
        popoverBg = [[UIView alloc] initWithFrame:self.bounds];
        popoverBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [self addSubview:popoverBg];
        
        popover = [[TableViewPopover alloc] initWithFrame:CGRectMake((rect.origin.x+rect.size.width/2-items.count*itemWidth), rect.origin.y, items.count*itemWidth+30, itemHeight)];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:popover.bounds];
        [popover addSubview:paddingView];
        [self addSubview:popover];
        [items enumerateObjectsUsingBlock:^(PopoverItem *obj, NSUInteger idx, BOOL *stop) {
            PopoverButton *button = [PopoverButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetWidth(popover.frame)/items.count *idx, 4, CGRectGetWidth(popover.frame)/items.count, CGRectGetHeight(popover.frame));
            button.tag = idx;
            button.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.5, 0.5), CGAffineTransformMakeTranslation(0, 0));
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:obj.name forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setImage:obj.image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(ss_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [paddingView addSubview:button];
            [popItemArr addObject:button];
        }];
        popover.layer.hidden = YES;
        objc_setAssociatedObject(self, PopoverKey, popover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, PopoverBtnKey, popItemArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, PopoverBgKey, popoverBg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }else {
        popover.frame = CGRectMake((rect.origin.x+rect.size.width/2-items.count*itemWidth), rect.origin.y, items.count*itemWidth+30, itemHeight);
        popItemArr = objc_getAssociatedObject(self, PopoverBtnKey);
        [popItemArr enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            button.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.5, 0.5), CGAffineTransformMakeTranslation(0, 0));
        }];
    }
    
    CGRect popoverFrame;
    TableViewPopoverDirection direction;
    direction = TableViewPopoverDirectionUp;
    popoverFrame = CGRectMake(popover.frame.origin.x, rect.origin.y-itemHeight, CGRectGetWidth(popover.frame), CGRectGetHeight(popover.frame));
    
    [self bringSubviewToFront:popover];
    popover.frame = popoverFrame;
    popover.direction = direction;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.075, 1.075, 1)],
                              [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    scaleAnimation.keyTimes = @[@(1),@(1),@(1)];
    
    CABasicAnimation *opAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opAnim.fromValue = [NSNumber numberWithFloat:0.0];
    opAnim.toValue = [NSNumber numberWithFloat:1.0];
    opAnim.cumulative = NO;
    opAnim.fillMode = kCAFillModeForwards;
    opAnim.removedOnCompletion = NO;
    
    CABasicAnimation *hiddenAnimation = [CABasicAnimation animationWithKeyPath:@"hidden"];
    hiddenAnimation.toValue = [NSNumber numberWithBool:NO];
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[opAnim,hiddenAnimation];
    groupAnimation.duration = 0.2;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.repeatCount = 1;
    popover.layer.hidden = NO;
    [popover.layer addAnimation:groupAnimation forKey:@"ani"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ss_tap:)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, PopoverTapGestureKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    popoverBg.hidden = NO;
    
    __block CGFloat afterTime = 0;
    [popItemArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
                btn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];

        });
        afterTime += 0.03;
    }];
}


#pragma mark Action

- (void)ss_buttonAction:(PopoverButton *)sender {
    NSArray *popoverItems = objc_getAssociatedObject(self, PopoverItemsKey);
    PopoverItem *popoverItem = popoverItems[sender.tag];
    popoverItem.index = sender.tag;
    if (popoverItem.handler) {
        popoverItem.handler(popoverItem);
    }
    [self ss_hide];
}

- (void)ss_tap:(UITapGestureRecognizer *)tap {
    [self ss_hide];
}

- (void)ss_hide {
    TableViewPopover *popover = objc_getAssociatedObject(self, PopoverKey);
    popover.layer.hidden = YES;
    
    UIView *popoverBg = objc_getAssociatedObject(self, PopoverBgKey);
    popoverBg.hidden = YES;
    
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, PopoverTapGestureKey);
    [self removeGestureRecognizer:tap];
    objc_setAssociatedObject(self, PopoverTapGestureKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, PopoverItemsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
