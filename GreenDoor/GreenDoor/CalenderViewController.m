//
//  CalenderViewController.m
//  GreenDoor
//
//  Created by Mohit Odhrani on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CalenderViewController.h"
#import "PDTSimpleCalendar.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"

@interface CalenderViewController () <PDTSimpleCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic, strong) NSArray *customDates;
@end

@implementation CalenderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showCalendar];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)showCalendar
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    _customDates = @[[dateFormatter dateFromString:@"01/05/2014"], [dateFormatter dateFromString:@"01/06/2014"], [dateFormatter dateFromString:@"01/07/2014"]];

    PDTSimpleCalendarViewController *calVC = [[PDTSimpleCalendarViewController alloc] init];
    //This is the default behavior, will display a full year starting the first of the current month
    [calVC setDelegate:self];

    PDTSimpleCalendarViewController *hebrewCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //Example of how you can change the default calendar
    //Other options you can try NSPersianCalendar, NSIslamicCalendar, NSIndianCalendar, NSJapaneseCalendar, NSRepublicOfChinaCalendar
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    hebrewCalendar.locale = [NSLocale currentLocale];
    [hebrewCalendarViewController setCalendar:hebrewCalendar];

    PDTSimpleCalendarViewController *dateRangeCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //For this calendar we're gonna allow only a selection between today and today + 3months.
    dateRangeCalendarViewController.firstDate = [NSDate date];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.month = 3;
    NSDate *lastDate =[dateRangeCalendarViewController.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    dateRangeCalendarViewController.lastDate = lastDate;

    //Set the edgesForExtendedLayout to UIRectEdgeNone
    if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
        [calVC setEdgesForExtendedLayout:UIRectEdgeNone];
        [hebrewCalendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [dateRangeCalendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    //Create Navigation Controller


    [self presentViewController:calVC animated:YES completion:^{
        
    }];
}



#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    NSLog(@"Date Selected : %@",date);
}

- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date
{
    if ([self.customDates containsObject:date]) {
        return YES;
    }

    return NO;
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date
{
    return [UIColor whiteColor];
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date
{
    return [UIColor orangeColor];
}

@end
