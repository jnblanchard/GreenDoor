//
//  EditReportViewController.m
//  GreenDoor
//
//  Created by John Blanchard on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "EditReportViewController.h"

@interface EditReportViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation EditReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.amountTextField.text = self.report[@"amount"];
    if ([self.amountTextField.text hasPrefix:@"-"]) {
        self.amountTextField.backgroundColor = [UIColor redColor];
        self.amountTextField.textColor = [UIColor whiteColor];
    } else {
        self.amountTextField.backgroundColor = [UIColor greenColor];
        self.amountTextField.textColor = [UIColor whiteColor];
    }
    self.datePicker.date = self.report[@"date"];
    self.descriptionTextField.text = self.report[@"description"];
    self.itemTextField.text = self.report[@"itemName"];
    if ([self.report[@"type"] isEqualToString:@"Other"] ) {
        self.typeSegmentedControl.selectedSegmentIndex = 0;
    }
    if ([self.report[@"type"] isEqualToString:@"Grocery"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 1;
    }
    if ([self.report[@"type"] isEqualToString:@"Transport"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 2;
    }
    if ([self.report[@"type"] isEqualToString:@"Utilities"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 3;
    }
    if ([self.report[@"type"] isEqualToString:@"Home"]) {
        self.typeSegmentedControl.selectedSegmentIndex = 4;
    }
    if ([self.report[@"rate"] isEqualToString:@"One Time"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 0;
    }
    if ([self.report[@"rate"] isEqualToString:@"Weekly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 1;
    }
    if ([self.report[@"rate"] isEqualToString:@"Monthly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 2;
    }
    if ([self.report[@"rate"] isEqualToString:@"Yearly"]) {
        self.rateSegmentedControl.selectedSegmentIndex = 3;
    }
    // Do any additional setup after loading the view.
}

- (IBAction)editingDidEnd:(id)sender
{

}


- (IBAction)expenseButtonPressed:(id)sender
{
}

- (IBAction)incomeButtonPressed:(id)sender
{
}

- (IBAction)addButtonPressed:(id)sender
{
    if (![self.descriptionTextField.text isEqualToString:@""] && ![self.itemTextField.text isEqualToString:@""] && ![self.amountTextField.text isEqualToString:@""]) {
        [self.report setObject:self.itemTextField.text forKey:@"itemName"];
        [self.report setObject:self.descriptionTextField.text forKey:@"description"];
        [self.report setObject:self.amountTextField.text forKey:@"amount"];
        [self.report setObject:[self.typeSegmentedControl titleForSegmentAtIndex:self.typeSegmentedControl.selectedSegmentIndex] forKey:@"type"];
        [self.report setObject:[self.rateSegmentedControl titleForSegmentAtIndex:self.rateSegmentedControl.selectedSegmentIndex] forKey:@"rate"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

        NSDateComponents *dateComponents = [calendar components:comps
                                                       fromDate: [self.datePicker date]];
        NSDate *date1 = [calendar dateFromComponents:dateComponents];
        [self.report setObject:date1 forKey:@"date"];
        [self.report saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Empty Field/s" message:@"Populate all fields" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    }
}

@end
