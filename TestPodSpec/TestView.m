//
//  TestView.m
//  Demo
//
//  Created by zhaochao on 2017/4/14.
//  Copyright © 2017年 zhaochao. All rights reserved.
//

#import "TestView.h"

@implementation TestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
 
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetFillColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    CGPathAddRect(path, NULL, rect);
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    CGMutablePathRef recordPath = CGPathCreateMutable();
    CGContextSetFillColorWithColor(currentContext, [UIColor blueColor].CGColor);
    CGPathAddRect(recordPath, NULL, CGRectMake(20, 0, 10, rect.size.height));
    CGContextAddPath(currentContext, recordPath);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(recordPath);
}


@end
