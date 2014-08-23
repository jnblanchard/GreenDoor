//
//  AddViewController.m
//  GreenDoor
//
//  Created by Mohit Odhrani on 8/23/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "AddViewController.h"
#import "Parse/Parse.h"

@interface AddViewController ()
@property (strong, nonatomic) IBOutlet UITextField *itemTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property PFUser* theUser;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property BOOL validItem;
@property BOOL validAmount;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property BOOL validDescription;
@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.theUser = [PFUser currentUser];
    self.validAmount = NO;
    self.validItem = NO;
    self.validDescription = NO;
}

- (IBAction)incomeButton:(id)sender
{
    if ([self.amountTextField.text hasPrefix:@"-"]) {
        self.amountTextField.text = [self.amountTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    self.amountTextField.backgroundColor = [UIColor greenColor];
    self.amountTextField.textColor = [UIColor whiteColor];
}

- (IBAction)expenseButton:(id)sender
{
    if ([self.amountTextField.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing an amount" message:@"Please enter $ amount" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    } else {
        if (![self.amountTextField.text hasPrefix:@"-"]) {
            self.amountTextField.text = [@"-" stringByAppendingString:self.amountTextField.text];
            self.amountTextField.textColor = [UIColor whiteColor];
            self.amountTextField.backgroundColor = [UIColor redColor];
        }
    }
}

- (IBAction)didEndOnExit:(UITextField*)sender
{
    if ([sender isEqual:self.itemTextField] && ![sender.text isEqualToString:@""]) {
        self.validItem = YES;
    }
    if ([sender isEqual:self.amountTextField] && ![sender.text isEqualToString:@""]) {
        self.validAmount = YES;
    }
    if ([sender isEqual:self.self.descriptionTextField] && ![sender.text isEqualToString:@""]) {
        self.validDescription = YES;
        self.datePicker.hidden = NO;
    }
    [sender resignFirstResponder];
}

- (IBAction)addItemAndAmount:(id)sender
{
    if(self.validAmount && self.validDescription && self.validItem)
    {
        PFObject* aReport = [PFObject objectWithClassName:@"Report"];
        aReport[@"itemName"] = self.itemTextField.text;
        aReport[@"description"] = self.descriptionTextField.text;
        aReport[@"amount"] = self.amountTextField.text;
        aReport[@"type"] = [self.typeSegmentedControl titleForSegmentAtIndex:self.typeSegmentedControl.selectedSegmentIndex];
        aReport[@"rate"] = [self.rateSegmentedControl titleForSegmentAtIndex:self.rateSegmentedControl.selectedSegmentIndex];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

        NSDateComponents *dateComponents = [calendar components:comps
                                                       fromDate: [self.datePicker date]];
        NSDate *date1 = [calendar dateFromComponents:dateComponents];
        NSLog(@"%@", date1);
        aReport[@"date"] = date1;
        [aReport setObject:self.theUser forKey:@"user"];
        [aReport saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                self.rateSegmentedControl.selectedSegmentIndex = 0;
                self.typeSegmentedControl.selectedSegmentIndex = 0;
                self.validItem = NO;
                self.itemTextField.text = @"";
                self.validAmount = NO;
                self.amountTextField.text = @"";
                self.amountTextField.backgroundColor = [UIColor whiteColor];
                self.amountTextField.textColor = [UIColor blackColor];
                self.validDescription = NO;
                self.descriptionTextField.text = @"";
            }
        }];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing report information..." message:@"Please enter valid entries for every component of the report." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    }
}

@end
