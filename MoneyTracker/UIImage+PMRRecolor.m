//
//  UIImage+PMRRecolor.m
//  DAFApp
//
//  Created by Pruthvikar Reddy on 14/03/2014.
//  Copyright (c) 2014 Pruthvikar Reddy. All rights reserved.
//

#import "UIImage+PMRRecolor.h"

@implementation UIImage (PMRRecolor)
-(UIImage*)colorAnImage:(UIColor*)color{
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}
@end
