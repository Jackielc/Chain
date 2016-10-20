//
//  UILabel+Category.m
//  QuickLabel
//
//  Created by jack on 16/10/17.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "UILabel+Category.h"
#import <objc/runtime.h>

@interface ColorTypeModel :NSObject

@property (nonatomic,strong)UIColor *color;
@property (nonatomic,assign)BOOL isbg;

@end

@implementation ColorTypeModel

@end


@implementation UILabel (Category)

- (UILabel * (^)(NSTextAlignment))CTextAlignment
{
    return ^(NSTextAlignment textAlignment){
        self.textAlignment = textAlignment;
        return self;
    };
}

- (UILabel * (^)(UIColor *))CTextColor
{
    return ^(UIColor *textColor){
        self.textColor = textColor;
        return self;
    };
}

- (UILabel * (^)(UIColor *))CBackgroundColor
{
    return ^(UIColor *backgroundColor){
        self.backgroundColor = backgroundColor;
        return self;
    };
}

- (UILabel * (^)(float))CFontSize
{
    return ^(float fontSize){
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

- (UILabel *(^)(CGRect))CRect
{
    return ^(CGRect frame){
        self.frame = frame;
        return self;
    };
}

- (UILabel * (^)(NSString *))CText
{
    return ^(NSString *text){
        self.text = text;
        return self;
    };
}

- (UILabel * (^)(UIView *))AddToSuperView
{
    return ^(UIView *view){
        [view addSubview:self];
        return self;
    };
}

#pragma mark Attributes
- (instancetype)init
{
    if (self = [super init]) {
        self.attributes = @[].mutableCopy;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_attributes"]) {
        NSLog(@"2");
    }
}

- (NSArray *)makeAttributes:(id)attribute, ...
{
    va_list params; va_start(params,attribute); id arg;
    if (attribute) {
        id prev = attribute;
        [self.attributes addObject:prev];
        while( (arg = va_arg(params,id))){
            if ( arg ){
                [self.attributes addObject:arg];
            }
        }
        va_end(params);
    }
    [self analysisWithObject:self.attributes];
    return self.attributes;
}

- (void)analysisWithObject:(NSMutableArray *)array
{
    if (!array) {
        return;
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSValue class]]&&![obj isKindOfClass:[NSNumber class]])
        {
            self.frame = [obj CGRectValue];
            
        }else if ([obj isKindOfClass:[NSString class]])
        {
            self.text = obj;
            
        }else if ([obj isKindOfClass:[NSNumber class]])
        {
            self.textAlignment = [(NSNumber *)obj integerValue];
            
        }else if ([obj isKindOfClass:[ColorTypeModel class]])
        {
            ColorTypeModel *model = obj;
            if (model.isbg)
                [self performSelector:@selector(setBackgroundColor:) withObject:model.color];
            else
                [self performSelector:@selector(setTextColor:) withObject:model.color];
        }else if([obj isKindOfClass:[UIFont class]]){
            [self performSelector:@selector(setFont:) withObject:obj];
        }else{
            [(UIView *)obj addSubview:self];
        }
    }];
}

- (void)setAttributes:(NSMutableArray *)attributes
{
    objc_setAssociatedObject(self, @selector(attributes), attributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)attributes
{
    NSMutableArray *attributesArray = objc_getAssociatedObject(self, @selector(attributes));
    [self analysisWithObject:attributesArray];
    return attributesArray;
}

NSValue * MakeRect(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = width; rect.size.height = height;
    return [NSValue valueWithCGRect:rect];
}

UIFont * MakeTextFont(UIFont *font)
{
    return font;
}

NSString * MakeText(NSString *text)
{
    return text;
}

ColorTypeModel * MakeTextColor(UIColor *tColor)
{
    ColorTypeModel *model = [[ColorTypeModel alloc]init];
    model.color = tColor;
    model.isbg = NO;
    return model;
}

ColorTypeModel * MakeBackgroundColor(UIColor *bgColor)
{
    ColorTypeModel *model = [[ColorTypeModel alloc]init];
    model.color = bgColor;
    model.isbg = YES;
    return model;
}

NSNumber * MakeTextAlignment(NSTextAlignment ali)
{
    return @(ali);
}

UIView *AddToSuperView(UIView *superView)
{
    return superView;
}

@end
