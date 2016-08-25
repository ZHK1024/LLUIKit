//
//  ViewController.m
//  Charts
//
//  Created by Apple-T on 16/3/1.
//  Copyright © 2016年 Apple-T. All rights reserved.
//

#import "ViewController.h"
#import "ChartLineView.h"
#import "ChartPoint.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    ChartLineView *lineView = [[ChartLineView alloc] initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, 200)];
    
    lineView.remarks = @[@"收缩压(mmol/l)", @"舒张压(mmol/l)"];
    lineView.maxValue = 100;
    lineView.data = @[
                      @[
                          [[ChartPoint alloc] initWithXValue:@"1" yValue:@2.3],
                          [[ChartPoint alloc] initWithXValue:@"2" yValue:@60],
                          [[ChartPoint alloc] initWithXValue:@"3" yValue:@30],
                          [[ChartPoint alloc] initWithXValue:@"4" yValue:@10],
                          [[ChartPoint alloc] initWithXValue:@"5" yValue:@40],
                          [[ChartPoint alloc] initWithXValue:@"6" yValue:@70],
                          [[ChartPoint alloc] initWithXValue:@"9" yValue:@18]
                          ],
                      @[
                          [[ChartPoint alloc] initWithXValue:@"1" yValue:@10],
                          [[ChartPoint alloc] initWithXValue:@"2" yValue:@20],
                          [[ChartPoint alloc] initWithXValue:@"3" yValue:@10],
                          [[ChartPoint alloc] initWithXValue:@"4" yValue:@40],
                          [[ChartPoint alloc] initWithXValue:@"5" yValue:@20],
                          [[ChartPoint alloc] initWithXValue:@"6" yValue:@50]
                          ]
                      ];
    [lineView drawLinesWithAnimation:YES];
    [self.view addSubview:lineView];
}

@end
