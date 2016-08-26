//
//  ChartLineView.h
//  Charts
//
//  Created by Apple-T on 16/3/1.
//  Copyright © 2016年 Apple-T. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChartLineView : UIView

/*!
 *  折线颜色
 */
@property (nonatomic, strong) NSArray<UIColor*> *linesColors;

/*!
 *  数据点颜色
 */
@property (nonatomic, strong) NSArray<UIColor*> *pointsColors;

/*!
 *  数据源
 */
@property (nonatomic, strong) NSArray<NSArray*> *data;

/*!
 *  Y 轴最大值
 */
@property (nonatomic, assign) CGFloat maxValue;

/*!
 *  Y 轴最小值
 */
@property (nonatomic, assign) CGFloat minValue;

/*!
 *  同一页显示数据点个数
 */
@property (nonatomic, assign) NSInteger showPointCount;

/*!
 *  线条注释
 */
@property (nonatomic, strong) NSArray<NSString*> *remarks;


/*!
 *  绘制折现
 *
 *  @param animation 是否添加动画路径
 */
- (void)drawLinesWithAnimation:(BOOL)animation;

/*!
 *  刷新
 */
- (void)refreshLines;

@end
