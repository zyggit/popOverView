//
//  UIView+popOverView.h
//  Pods-popOverView_Example
//
//  Created by zhaoyuguang on 2018/5/17.
//

#import <UIKit/UIKit.h>

@class PopoverItem;

typedef void(^PopoverItemSelectHandler)(PopoverItem *popoverItem);

@interface PopoverItem : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,readonly,  copy) NSString *name;
@property (nonatomic,readonly,strong) UIImage *image;
@property (nonatomic,readonly,  copy) PopoverItemSelectHandler handler;

+ (instancetype)itemWithName:(NSString *)name
                       image:(UIImage *)image
             selectedHandler:(PopoverItemSelectHandler)handler;

@end


@interface UIView (popOverView)

- (void)showPopoverWithItems:(NSArray <PopoverItem *>*)items
                     forRect:(CGRect )rect;

- (void)ss_hide;
@end
