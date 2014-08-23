//
//  GraphViewController.m
//  GreenDoor
//
//  Created by John Blanchard on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "GraphViewController.h"
#import <ShinobiCharts/ShinobiCharts.h>


@interface GraphViewController () <SChartDatasource>
@property ShinobiChart* chart;
@end

@implementation GraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    self.chart.title = @"Trigonometric Functions";

    self.chart.licenseKey = @"Yo4qzAHywKn0qvVMjAxNDA5MjJqbmJsYW5jaGFyZEBtYWMuY29trMV1GXfqeYP4GjjsB1dDDbPUmHVSHQkJAJQqpKM6feF5BrUFY8k9aaK4InUNRfCtQT+EgT4I851spCJLFzBtBEy/lawg0mAxLWtfyqR8Qw5EeWVuZkc37t0qyQeAlOmFrzGe/8eidlnpqaSLbS5xHt0bRNuM=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+"; // TODO: add your trial licence key here!
    self.chart.autoresizingMask = ~UIViewAutoresizingNone;

    SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
    self.chart.xAxis = xAxis;

    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    self.chart.yAxis = yAxis;

    [self.view addSubview:_chart];

}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {

    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];

    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        lineSeries.title = [NSString stringWithFormat:@"y = cos(x)"];
    } else {
        lineSeries.title = [NSString stringWithFormat:@"y = sin(x)"];
    }

    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 100;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {

    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];

    // both functions share the same x-values
    double xValue = dataIndex / 10.0;
    datapoint.xValue = [NSNumber numberWithDouble:xValue];

    // compute the y-value for each series
    if (seriesIndex == 0) {
        datapoint.yValue = [NSNumber numberWithDouble:cosf(xValue)];
    } else {
        datapoint.yValue = [NSNumber numberWithDouble:sinf(xValue)];
    }

    return datapoint;
}




@end
