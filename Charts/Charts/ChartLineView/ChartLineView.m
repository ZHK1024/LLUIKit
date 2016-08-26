//
//  ChartLineView.m
//  Charts
//
//  Created by Apple-T on 16/3/1.
//  Copyright © 2016年 Apple-T. All rights reserved.
//

#import "ChartLineView.h"
#import "ChartLine.h"
#import "ChartPoint.h"

#define PADDING_LEFT 15.0
#define PADDING_TOP 10.0
#define PADDING_BOTTOM 30.0
#define X_TITLE_HEIGHT 20.0
#define FONT_SIZE_REMARK 12.0
#define FONT_SIZE_X_TITLE 10.0

@interface ChartLineView ()

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray *xAreaTitle;
@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, assign) CGFloat         space;
@property (nonatomic, strong) UIView         *contentView;

@end

@implementation ChartLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        self.backgroundColor = [self colorWithRed:249 green:232 blue:226 alpha:0.7];
    }
    return self;
}

/*!
 *  绘制折线
 */
- (void)drawLinesWithAnimation:(BOOL)animation {
    if (self.data.count == 0) {
        [self showNoData];
        return;
    }
    if (![self isColorCountEnough]) {
        return;
    }

    [self formatDataPoint];

    if (_showPointCount == 0) {
        _showPointCount = 5;
    }
    NSInteger count = 0;
    if (_showPointCount > self.xAreaTitle.count) {
        count = self.xAreaTitle.count;
    }else {
        count = _showPointCount;
    }
    CGFloat space = (CGRectGetWidth(self.frame) - PADDING_LEFT * 2) / count;
    
    for (NSInteger i = 0; i < self.data.count; ++i) {
        NSArray *points = self.data[i];
        ChartLine *linePath = [self makeLinePathWithPoints:points xSpace:space lineColor:self.linesColors[i]];
        [self.lines addObject:linePath];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0;
        animation.toValue = @1.0;
        animation.duration = 1.5;
        [linePath addAnimation:animation forKey:@""];
        
        [self.contentView.layer addSublayer:linePath];
    }
    
    [self.scrollView addSubview:self.contentView];

    [self layoutContentView];
    [self showTextLabels];
    [self showXValues];
    [self showRemarks];
}

/*!
 *  调整内容视图大小以及布局
 */
- (void)layoutContentView {
    CGFloat width = 0;
    if (_xAreaTitle.count < _showPointCount) {
        width = CGRectGetWidth(self.scrollView.frame);
    }else {
        width = (CGRectGetWidth(self.scrollView.frame) / _showPointCount) * _xAreaTitle.count;
    }
    _contentView.frame = CGRectMake(0, 0, width, CGRectGetHeight(_scrollView.frame) - X_TITLE_HEIGHT);
    _scrollView.contentSize = _contentView.frame.size;
    
    UIColor *separateColor = [UIColor grayColor];
    CALayer *separate = [CALayer new];
    separate.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 1, CGRectGetWidth(self.contentView.frame), 1);
    separate.backgroundColor = separateColor.CGColor;
    [_contentView.layer addSublayer:separate];
}

- (void)refreshLines {
    
}

/*!
 *  处理数据点
 */
- (void)formatDataPoint {
    if (self.data.count <= 1) {
        NSArray *points = [self.data firstObject];
        for (NSInteger i = 0; i < [points count]; ++i) {
            ChartPoint *point = points[i];
            [point setIndex:i];
            [self.xAreaTitle addObject:point.xValue];
        }
    }else {
        NSMutableArray *tempArray = [NSMutableArray new];
        // 把所有数据的放进同一个数组
        for (NSArray *array in _data) {
            [tempArray addObjectsFromArray:array];
        }
        // 对数组进行排序
        [tempArray sortUsingComparator:^NSComparisonResult(ChartPoint *obj1, ChartPoint *obj2) {
            NSComparisonResult result = [obj1.xValue compare:obj2.xValue options:NSNumericSearch];
            return result;
        }];
        [self setPointsAreaIndex:tempArray];
    }
}

/*!
 *  设置每个 point 的 areaIndex
 *
 *  @param tempArray point 的容器数组
 */
- (void)setPointsAreaIndex:(NSArray<ChartPoint *> *)tempArray {
    //
    NSInteger index = 0;
    for (NSInteger i = 0; i < tempArray.count; i++) {
        if (i == 0) {
            ChartPoint *p = tempArray[i];
            [self.xAreaTitle addObject:p.xValue];
            [p setIndex:index];
        }else {
            ChartPoint *p1 = tempArray[i - 1];
            ChartPoint *p2 = tempArray[i];
            if ([p2.xValue isEqualToString:p1.xValue]) {
                [p2 setIndex:p1.areaIndex];
                
            }else {
                index++;
                [p2 setIndex:index];
                [self.xAreaTitle addObject:p2.xValue];
            }
        }
    }
}

#pragma mark -

/*!
 *  生成折线路径
 *
 *  @return 折线路径
 */
- (ChartLine *)makeLinePathWithPoints:(NSArray *)points xSpace:(CGFloat)space lineColor:(UIColor *)color {
    CGFloat height = CGRectGetHeight(self.frame) - PADDING_TOP - PADDING_BOTTOM - X_TITLE_HEIGHT;
    if (_maxValue == 0) {
        _maxValue = 100;
    }
    CGFloat scale = height / _maxValue;
    return [ChartLine linePathWithPoints:points valueScale:scale areaHeight:height xSpace:space lineColor:color];
}

/*!
 *  添加显示数据的 label
 */
- (void)showTextLabels {
    for (NSInteger i = 0; i < self.data.count; ++i) {
        NSArray *points = self.data[i];
        for (ChartPoint *point in points) {
            UILabel *label = [UILabel new];
            label.textColor = self.linesColors[i];
            label.text = [point.yValue stringValue];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:10];
            [label sizeToFit];
            label.center = CGPointMake(point.point.x, point.point.y - 6);
            [self.contentView addSubview:label];
        }
    }
}

/*!
 *  显示横轴坐标
 */
- (void)showXValues {
    CGFloat width = CGRectGetWidth(_contentView.frame) / _xAreaTitle.count;
    for (NSInteger i = 0; i < self.xAreaTitle.count; ++i) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:FONT_SIZE_X_TITLE];
        label.frame = CGRectMake(i * width, CGRectGetHeight(self.contentView.frame), width, X_TITLE_HEIGHT);
        label.text = self.xAreaTitle[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
    }
}

/*!
 *  显示备注
 */
- (void)showRemarks {
    if (self.remarks.count > self.linesColors.count) {
        return;
    }
    CGFloat margin = 10.0;
    CGFloat y = CGRectGetMaxY(self.scrollView.frame) + PADDING_BOTTOM / 2;
    CGFloat x = PADDING_LEFT + margin;
    CGFloat lineWidth = 10.0;
    CGFloat lineHeight = 2.0;
    for (NSInteger i = 0; i < self.remarks.count; ++i) {
        CALayer *line = [CALayer new];
        line.frame = CGRectMake(x, y, lineWidth, lineHeight);
        line.backgroundColor = self.linesColors[i].CGColor;
        x += (5 + lineWidth);
        
        UILabel *textLabel = [UILabel new];
        textLabel.font = [UIFont systemFontOfSize:FONT_SIZE_REMARK];
        textLabel.text = self.remarks[i];
        [textLabel sizeToFit];
        textLabel.frame = CGRectMake(x, CGRectGetHeight(self.frame) - PADDING_BOTTOM, CGRectGetWidth(textLabel.frame), PADDING_BOTTOM);
        
        x += (margin + CGRectGetWidth(textLabel.frame));
        
        [self.layer addSublayer:line];
        [self addSubview:textLabel];
    }
}

- (BOOL)isColorCountEnough {
    if (self.data.count <= self.linesColors.count) {
        return YES;
    }
    return NO;
}

#pragma mark - Private method

/*!
 *  提醒没有数据
 */
- (void)showNoData {
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"没有数据";
    tipLabel.font = [UIFont systemFontOfSize:12];
    [tipLabel sizeToFit];
    [self addSubview:tipLabel];
    tipLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
}

/*!
 *  通过 R G B A 生成颜色
 *
 *  @param red   红色色值
 *  @param green 绿色色值
 *  @param blue  蓝色色值
 *  @param alpha 透明度
 *
 *  @return  UIColor 对象
 */
- (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:alpha];
}

#pragma mark - Getter

- (NSArray<UIColor *> *)linesColors {
    if (_linesColors == nil) {
        self.linesColors = @[
                             [self colorWithRed:240 green:102 blue:114 alpha:1],
                             [self colorWithRed:125 green:202 blue:197 alpha:1]
                             ];
    }
    return _linesColors;
}

- (NSMutableArray *)lines {
    if (_lines == nil) {
        self.lines = [NSMutableArray new];
    }
    return _lines;
}

- (NSMutableArray *)xAreaTitle {
    if (_xAreaTitle == nil) {
        self.xAreaTitle = [NSMutableArray new];
    }
    return _xAreaTitle;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(PADDING_LEFT, PADDING_TOP, CGRectGetWidth(self.frame) - PADDING_LEFT * 2, CGRectGetHeight(self.frame) - PADDING_TOP - PADDING_BOTTOM)];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        self.contentView = [UIView new];
    }
    return _contentView;
}

@end
