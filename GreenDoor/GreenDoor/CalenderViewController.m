//
//  CalenderViewController.m
//  GreenDoor
//
//  Created by Mohit Odhrani on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CalenderViewController.h"
#import "TheCalendarViewController.h"
#import "EditReportViewController.h"
#import <Parse/Parse.h>

@interface CalenderViewController () <UITableViewDelegate, UITableViewDataSource, TheCalendarProtocol>
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *reportsArray;
@end

@implementation CalenderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    for (UIViewController* vc in self.childViewControllers) {
        if ([vc isKindOfClass:[TheCalendarViewController class]]) {
            // do something here
            TheCalendarViewController *tvc = (TheCalendarViewController *)vc;
            tvc.delegateCalendar = self;
        }
    }
    // Do any additional setup after loading the view.
}

- (void)theCalendarProtocol:(TheCalendarViewController *)vc didSelectDateWithReports:(NSDate *)date
{
    NSLog(@"date %@",date);
    PFQuery *query = [PFQuery queryWithClassName:@"Report"];
    [query whereKey:@"date" equalTo:date];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"OBJECTS %@", objects);
        self.reportsArray = objects;
        [self.tableView reloadData];
    }];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PFObject *report = [self.reportsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [report objectForKey:@"itemName"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reportsArray.count;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editReport"]) {
        EditReportViewController *vc = segue.destinationViewController;
        PFObject *report = [self.reportsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];

        vc.report = report;
    }
}

@end
