//
//  PNBar.h
//  PNChartDemo
//
//  Created by hongliang li on 17-11-29.
//  Copyright (c) 2017年 hongliang li . All rights reserved.
//
//

#import "DAUUChart.h"
@interface DAUUChart ()

@property (strong, nonatomic) DAUULineChart * lineChart;

@property (strong, nonatomic) DAUUBarChart * barChart;

@property (assign, nonatomic) id<UUChartDataSource> dataSource;

@property (assign, nonatomic) NSInteger yLabelRow;

@end

@implementation DAUUChart

- (id)initWithFrame:(CGRect)rect dataSource:(id<UUChartDataSource>)dataSource style:(UUChartStyle)style
{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        //这里的clip是修剪的意思，bounds是边界的意思是，合起来就是：如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
    }
    return self;
}

-(void)setUpChart{
	if (self.chartStyle == UUChartStyleLine) {
        if(!_lineChart){
            _lineChart = [[DAUULineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_lineChart];
        }
        //选择标记范围
        if ([self.dataSource respondsToSelector:@selector(chartHighlightRangeInLine:)]) {
            [_lineChart setMarkRange:[self.dataSource chartHighlightRangeInLine:self]];
        }
        
        //y轴分几个
        if ([self.dataSource respondsToSelector:@selector(chartYLabelRow:)]) {
            self.yLabelRow = [self.dataSource chartYLabelRow:self];
            [_lineChart setYLabelCount:[self.dataSource chartYLabelRow:self]];
        }else{
            self.yLabelRow  = 10;
            [_lineChart setYLabelCount:10];
        }
        
        //是否隐藏滑动按钮
        if ([self.dataSource respondsToSelector:@selector(charthiddleSlide:)]) {
            [_lineChart setHiddleSlide:[self.dataSource charthiddleSlide:self]];
        }
        
        //标准线
        if ([self.dataSource respondsToSelector:@selector(chartHighlightInLine:)]) {
            [_lineChart setLineArray:[self.dataSource chartHighlightInLine:self]];
        }
        
        //标准线颜色
        if ([self.dataSource respondsToSelector:@selector(chartHighlightInLineColor:)]) {
            [_lineChart setLineColorArray:[self.dataSource chartHighlightInLineColor:self]];
        }
        
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [_lineChart setChooseRange:[self.dataSource chartRange:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(chartConfigColors:)]) {
            [_lineChart setColors:[self.dataSource chartConfigColors:self]];
        }
        //显示横线
        if ([self.dataSource respondsToSelector:@selector(chart:showHorizonLineAtIndex:)]) {
            NSMutableArray *showHorizonArray = [[NSMutableArray alloc]init];
            for (int i=0; i < YkCount; i++) {
                if ([self.dataSource chart:self showHorizonLineAtIndex:i]) {
                    [showHorizonArray addObject:@"1"];
                }else{
                    [showHorizonArray addObject:@"0"];
                }
            }
            [_lineChart setShowHorizonLine:showHorizonArray];

        }
        
        //显示竖线
        if ([self.dataSource respondsToSelector:@selector(chart:showVerticalLine:)]) {
            NSMutableArray *showHorizonArray = [[NSMutableArray alloc]init];
            for (int i=0; i < self.yLabelRow; i++) {
                if ([self.dataSource chart:self showVerticalLine:i]) {
                    [showHorizonArray addObject:@"1"];
                }else{
                    [showHorizonArray addObject:@"0"];
                }
            }
            [_lineChart setShowVerticalLine:showHorizonArray];
            
        }
        
        //判断显示最大最小值
        if ([self.dataSource respondsToSelector:@selector(chart:showMaxMinAtIndex:)]) {
            NSMutableArray *showMaxMinArray = [[NSMutableArray alloc]init];
            NSArray *y_values = [self.dataSource chartConfigAxisYValue:self];
            if (y_values.count>0){
                for (int i=0; i<y_values.count; i++) {
                    if ([self.dataSource chart:self showMaxMinAtIndex:i]) {
                        [showMaxMinArray addObject:@"1"];
                    }else{
                        [showMaxMinArray addObject:@"0"];
                    }
                }
                _lineChart.showMaxMinArray = showMaxMinArray;
            }
        }
        
		[_lineChart setYValues:[self.dataSource chartConfigAxisYValue:self]];
		[_lineChart setXLabels:[self.dataSource chartConfigAxisXLabel:self]];
        
		[_lineChart strokeChart];

	}else if (self.chartStyle == UUChartStyleBar)
	{
        if (!_barChart) {
            _barChart = [[DAUUBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [_barChart setChooseRange:[self.dataSource chartRange:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(chartConfigColors:)]) {
            [_barChart setColors:[self.dataSource chartConfigColors:self]];
        }
		[_barChart setYValues:[self.dataSource chartConfigAxisYValue:self]];
		[_barChart setXLabels:[self.dataSource chartConfigAxisXLabel:self]];
        
        [_barChart strokeChart];
	}
}

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
	[self setUpChart];
	
}



@end
