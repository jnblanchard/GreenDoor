//
//  TheCalendarViewController.m
//  GreenDoor
//
//  Created by Ivan Ruiz Monjo on 23/08/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "TheCalendarViewController.h"
#import "CalenderViewController.h"
#import "PDTSimpleCalendar.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"
#import <Parse/Parse.h>


@interface TheCalendarViewController () <PDTSimpleCalendarViewDelegate>
@property (nonatomic, strong) NSArray *customDates;
@property NSArray *reportsArray;


@end

@implementation TheCalendarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getReports];
    [self showCalendar];

//    NSDate *date = [NSDate date];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
//
//    NSDateComponents *dateComponents = [calendar components:comps
//                                                   fromDate: date];
//    NSDate *finalDate = [calendar dateFromComponents:dateComponents];
//    NSLog(@"FINAL DATE %@",finalDate);

    // Do any additional setup after loading the view.
}

- (void)getReports
{
    PFQuery *query = [PFQuery queryWithClassName:@"Report"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.reportsArray = objects;
        [self.collectionView reloadData];
        
    }];
}

- (void)showCalendar
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";


    //This is the default behavior, will display a full year starting the first of the current month
    [self setDelegate:self];


    //Set the edgesForExtendedLayout to UIRectEdgeNone
    if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    //Create Navigation Controller


}



#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

    NSDateComponents *dateComponents = [calendar components:comps
                                                   fromDate: date];

    NSDate *date1 = [calendar dateFromComponents:dateComponents];

    [self.delegateCalendar theCalendarProtocol:self didSelectDateWithReports:date1];
}

- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date
{
    return YES;
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date
{
    for (PFObject *report in self.reportsArray) {
        NSDate *dateReport = [report objectForKey:@"date"];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

        NSDateComponents *dateComponents = [calendar components:comps
                                                        fromDate: date];
        NSDateComponents *dateReportComponents = [calendar components:comps
                                                        fromDate: dateReport];

        NSDate *date1 = [calendar dateFromComponents:dateComponents];
        NSDate *date2 = [calendar dateFromComponents:dateReportComponents];
        NSComparisonResult result = [date1 compare:date2];
        if (result == NSOrderedAscending) {
        } else if (result == NSOrderedDescending) {
        }  else {
            return [UIColor colorWithRed:1 green:0.51 blue:0.51 alpha:0.5];
        }
    }
    return [UIColor whiteColor];
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date
{
    return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
}

@end
