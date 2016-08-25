//
//  ChartLine.h
//  Charts
//
//  Created by Apple-T on 16/3/1.
//  Copyright © 2016年 Apple-T. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ChartLine : CAShapeLayer

+ (instancetype)linePathWithPoints:(NSArray *)points
                        valueScale:(CGFloat)scale
                        areaHeight:(CGFloat)areaHeight
                            xSpace:(CGFloat)space
                         lineColor:(UIColor *)lineColor;

@end
