//
//  ChartPoint.m
//  Charts
//
//  Created by Apple-T on 16/3/1.
//  Copyright © 2016年 Apple-T. All rights reserved.
//

#import "ChartPoint.h"

@interface ChartPoint ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation ChartPoint

- (instancetype)initWithXValue:(NSString *)xVaule yValue:(NSNumber *)yValue {
    if (self = [super init]) {
        self.xValue = xVaule;
        self.yValue = yValue;
        _index = -1;
    }
    return self;
}

- (NSInteger)areaIndex {
    return _index;
}

- (void)setIndex:(NSInteger)index {
    if (_index != index) {
        _index = index;
    }
}

@end
