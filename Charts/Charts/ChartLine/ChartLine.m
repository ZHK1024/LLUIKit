//
//  ChartLine.m
//  Charts
//
//  Created by Apple-T on 16/3/1.
//  Copyright © 2016年 Apple-T. All rights reserved.
//

#import "ChartLine.h"
#import "ChartPoint.h"

#define X_SCALE 0.3
#define Y_SCALE 0.8

@implementation ChartLine

+ (instancetype)linePathWithPoints:(NSArray *)points
                        valueScale:(CGFloat)scale
                        areaHeight:(CGFloat)areaHeight
                            xSpace:(CGFloat)space
                         lineColor:(UIColor *)lineColor {
    ChartLine *path = [ChartLine new];
    path.strokeColor = lineColor.CGColor;
    path.fillColor = [UIColor clearColor].CGColor;
    path.lineWidth = 2;
    [path makePathWithPoints:points xSpace:space scale:scale areaHeight:areaHeight];
    
    return path;
}

- (void)makePathWithPoints:(NSArray *)points xSpace:(CGFloat)space scale:(CGFloat)scale areaHeight:(CGFloat)height {
    if (points.count <= 1) {
        ChartPoint *point = [points firstObject];
        point.point = [self makeChartPoint2CGPoint:point space:space scale:scale areaHeight:height];
        return;
    }
    UIBezierPath *path = [UIBezierPath new];
    CGPoint point = [self makeChartPoint2CGPoint:points[0] space:space scale:scale areaHeight:height];
    [path moveToPoint:point];

    CGPoint ep;
    for (NSInteger i = 0; i < points.count - 1; ++i) {
        ChartPoint *leftPoint = nil;
        ChartPoint *rightPoint = nil;
        if (i == points.count - 1) {
            leftPoint = points[i - 1];
            rightPoint = points[i];
        }else {
            leftPoint = points[i];
            rightPoint = points[i + 1];
        }
        
        CGPoint startPoint = [self makeChartPoint2CGPoint:leftPoint space:space scale:scale areaHeight:height];
        CGPoint endPoint = [self makeChartPoint2CGPoint:rightPoint space:space scale:scale areaHeight:height];
        CGPoint controlPoint1 = [self makeControlPoint:startPoint endPoint:endPoint isControl1:YES];
        CGPoint controlPoint2 = [self makeControlPoint:startPoint endPoint:endPoint isControl1:NO];
        
        leftPoint.point = startPoint;
        rightPoint.point = endPoint;
        
        [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        ep = endPoint;
    }

    self.path = path.CGPath;
}

- (CGPoint)makeChartPoint2CGPoint:(ChartPoint *)point space:(CGFloat)space scale:(CGFloat)scale areaHeight:(CGFloat)height {
    CGFloat x = point.areaIndex * space + space / 2;
    CGFloat y = height - [point.yValue floatValue] * scale;
    return CGPointMake(x, y);
}

- (CGPoint)makeControlPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint isControl1:(BOOL)isControl1 {
    CGFloat xOffset = endPoint.x - startPoint.x;
    CGFloat yOffset = endPoint.y - startPoint.y;

    CGFloat x = 0;
    CGFloat y = 0;
    
    if (isControl1) {
        x = startPoint.x + xOffset * X_SCALE;
        y = startPoint.y + yOffset * Y_SCALE;
        y = startPoint.y;
    }else {
        x = endPoint.x - xOffset * X_SCALE;
        y = endPoint.y - yOffset * Y_SCALE;
        y = endPoint.y;
    }
    
    return CGPointMake(x, y);
}

@end
