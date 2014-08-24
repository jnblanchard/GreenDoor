//
//  GraphViewController.m
//  GreenDoor
//
//  Created by John Blanchard on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "GraphViewController.h"
#import <ShinobiCharts/ShinobiCharts.h>
#import "Parse/Parse.h"


@interface GraphViewController () <SChartDatasource>
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *differentialLabel;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property ShinobiChart* chart;
@property ShinobiChart* chartTwo;
@property NSArray* dataArray;
@property NSDate* minDate;
@property NSDate* maxDate;
@property NSMutableArray* dateArray;
@property int totalCash;
@property int negativeCash;
@property int positiveCash;
@property double percentageOfNegative;
@end

@implementation GraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];

}

- (void)loadData
{
    PFQuery* query = [PFQuery queryWithClassName:@"Report"];
    [query orderByAscending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.dataArray = objects;
            [self.chart reloadData];
        }
        NSMutableArray* array = [NSMutableArray new];
        NSMutableArray* cashArray = [NSMutableArray new];
        for (PFObject* report in self.dataArray) {
            [array addObject:report[@"date"]];
            [cashArray addObject:report[@"amount"]];
        }
        self.minDate = [self findMinDate:array];
        self.maxDate = [self findMaxDate:array];
        self.negativeCash = 0;
        self.totalCash = [self findTotalCash:cashArray];
        self.percentageOfNegative = ((double)self.negativeCash) / self.totalCash;
        int cashDifferential = self.positiveCash - self.negativeCash;
        NSString* cash = [NSString stringWithFormat:@"%i", cashDifferential];
        cash = [cash stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (cashDifferential < 0) {
            self.differentialLabel.textColor = [UIColor redColor];
            self.differentialLabel.text = [NSString stringWithFormat:@"Revenue: $ -%@", cash];
        } else {
            self.differentialLabel.textColor = [UIColor greenColor];
            self.differentialLabel.text = [NSString stringWithFormat:@"Revenue: $ %@", cash];
        }
        CGFloat width = self.view.bounds.size.width * self.percentageOfNegative;
        CGFloat x = self.view.bounds.size.width - width;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(x , self.innerView.bounds.origin.y, width, self.differentialLabel.bounds.size.height+37)];
        label.backgroundColor = [UIColor redColor];
        [self.innerView addSubview:label];
        CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
        self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(CGRectMake(self.view.bounds.origin.x-10, self.view.bounds.origin.y+84, self.view.bounds.size.width+18, self.view.bounds.size.height - 125), margin, margin)];
        self.chart.title = @"Reports: Line Graph";

        self.chart.licenseKey = @"Yo4qzAHywKn0qvVMjAxNDA5MjJqbmJsYW5jaGFyZEBtYWMuY29trMV1GXfqeYP4GjjsB1dDDbPUmHVSHQkJAJQqpKM6feF5BrUFY8k9aaK4InUNRfCtQT+EgT4I851spCJLFzBtBEy/lawg0mAxLWtfyqR8Qw5EeWVuZkc37t0qyQeAlOmFrzGe/8eidlnpqaSLbS5xHt0bRNuM=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+"; // TODO: add your trial licence key here!
        self.chart.autoresizingMask = ~UIViewAutoresizingNone;

        SChartDateRange* dateRange = [[SChartDateRange alloc]initWithDateMinimum:self.minDate andDateMaximum:self.maxDate];
        SChartDateTimeAxis* xAxis = [[SChartDateTimeAxis alloc]initWithRange:dateRange];
        self.chart.xAxis = xAxis;

        SChartNumberRange* rangeY = [[SChartNumberRange alloc]initWithMinimum:[NSNumber numberWithInteger:-3000] andMaximum:[NSNumber numberWithInteger:3000]];
        SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] initWithRange:rangeY];
        self.chart.yAxis = yAxis;

        [self.view addSubview:self.chart];

        self.chart.datasource = self;
    }];
}



-(NSMutableArray*)orderArray:(NSMutableArray*)array
{
    NSMutableArray* newArray = [NSMutableArray new];
    NSDate* min = array.firstObject;
    while (array.count != 0) {
        for (NSDate* date in array) {
            if ([min isEqual:[date laterDate:min]]) {
                min = date;
            }
        }
        [newArray addObject:min];
        [array removeObject:min];
    }
    return newArray;
}

-(int)findTotalCash:(NSMutableArray*)array
{
    int total = 0;
    NSString* newString;
    NSString* newNegativeString;
    for (NSString* cashAmount in array) {
        if ([cashAmount hasPrefix:@"-"]) {
            newNegativeString = [cashAmount stringByReplacingOccurrencesOfString:@"-" withString:@""];
            self.negativeCash += newNegativeString.intValue;
        } else {
            self.positiveCash += cashAmount.intValue;
        }
        newString = [cashAmount stringByReplacingOccurrencesOfString:@"-" withString:@""];
        total += newString.intValue;
    }
    return total;
}

-(NSDate*)findMinDate:(NSArray*)array
{
    NSDate* min = array.firstObject;
    for (NSDate* date in array) {
        if ([min isEqual:[date laterDate:min]]) {
            min = date;
        }
    }
    NSDate *currentDate = min;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: currentDate options:0];
    return nextDate;
}

-(NSDate*)findMaxDate:(NSArray*)array
{
    NSDate* max = array.firstObject;
    for (NSDate* date in array) {
        if (![max isEqual:[date laterDate:max]]) {
            max = date ;
        }
    }
    NSDate *currentDate = max;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: currentDate options:0];
    return nextDate;

}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {

    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    lineSeries.baseline = [NSNumber numberWithInt:0];

    SChartNumberRange* rangeX = [[SChartNumberRange alloc]initWithMinimum:[NSNumber numberWithInteger:0] andMaximum:[NSNumber numberWithInteger:400]];
    SChartNumberRange* rangeY = [[SChartNumberRange alloc]initWithMinimum:[NSNumber numberWithInteger:-3000] andMaximum:[NSNumber numberWithInteger:3000]];
    SChartDataSeries* series = [[SChartDataSeries alloc] init];

    SChartLineSeriesStyle* style = [[SChartLineSeriesStyle alloc] init];
    [style setLineWidth:[NSNumber numberWithInt:3]];
    SChartPointStyle* pointStyle = [SChartPointStyle new];
    pointStyle.color = [UIColor greenColor];
    pointStyle.colorBelowBaseline = [UIColor redColor];
    pointStyle.showPoints = YES;
    [pointStyle setRadius:[NSNumber numberWithInt:10]];
    [pointStyle setInnerRadius:[NSNumber numberWithInt:6]];
    style.pointStyle = pointStyle;
    [style setLineColor:[UIColor greenColor]];
    [style setLineColorBelowBaseline:[UIColor redColor]];
    [lineSeries setStyle:style];


    [series setRangeX:rangeX];
    [series setRangeY:rangeY];

    [lineSeries setDataSeries:series];

    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return self.dataArray.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex{

    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    PFObject* report = [self.dataArray objectAtIndex:dataIndex];
    NSDate* date = report[@"date"];



    NSString* amount = report[@"amount"];
    int amountInt = amount.intValue;

    // both functions share the same x-values
    datapoint.xValue = date;

    // compute the y-value for each series
    datapoint.yValue = [NSNumber numberWithInt:amountInt];

    return datapoint;
}




@end
