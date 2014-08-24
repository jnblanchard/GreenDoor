//
//  CalenderViewController.m
//  GreenDoor
//
//  Created by Mohit Odhrani on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CalenderViewController.h"
#import "TheCalendarViewController.h"
#import "CalendarViewCell.h"
#import <Parse/Parse.h>
#import "DetailReportViewController.h"

@interface CalenderViewController () <UITableViewDelegate, UITableViewDataSource, TheCalendarProtocol>
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *reportsArray;
@end

@implementation CalenderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    for (UIViewController* vc in self.childViewControllers) {
        if ([vc isKindOfClass:[TheCalendarViewController class]]) {
            // do something here
            TheCalendarViewController *tvc = (TheCalendarViewController *)vc;
            tvc.delegateCalendar = self;
        }
    }
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)theCalendarProtocol:(TheCalendarViewController *)vc didSelectDateWithReports:(NSDate *)date
{
    NSLog(@"date %@",date);
    PFQuery *query = [PFQuery queryWithClassName:@"Report"];
    [query whereKey:@"date" equalTo:date];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.reportsArray = objects;
        [self.tableView reloadData];
    }];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PFObject *report = [self.reportsArray objectAtIndex:indexPath.row];
    cell.reportLabel.text = [report objectForKey:@"itemName"];
    cell.descriptionLabel.text = [report objectForKey:@"description"];
    cell.dueLabel.text = [report objectForKey:@"amount"];
    cell.typeImageView.image = [UIImage imageNamed:[report objectForKey:@"type"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reportsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detail" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"editReport"]) {
//        EditReportViewController *vc = segue.destinationViewController;
//        PFObject *report = [self.reportsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
//        vc.comingFrom = @"backToCalendar";
//        vc.report = report;
//    }
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetailReportViewController *dvc = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        dvc.object = [self.reportsArray objectAtIndex:indexPath.row];
    }
}

@end
