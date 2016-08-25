//
//  ChartPoint.h
//  Charts
//
//  Created by Apple-T on 16/3/1.
//  Copyright © 2016年 Apple-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChartPoint : NSObject

/*!
 *  x 轴值
 */
@property (nonatomic, strong) NSString *xValue;

/*!
 *  y 轴值
 */
@property (nonatomic, strong) NSNumber *yValue;

@property (nonatomic, assign) CGPoint   point;

/*!
 *  数据点所属 X 轴划分区间
 */
@property (nonatomic, assign, readonly) NSInteger areaIndex;


- (instancetype)initWithXValue:(NSString *)xVaule yValue:(NSNumber *)yValue;

- (void)setIndex:(NSInteger)index;

@end
